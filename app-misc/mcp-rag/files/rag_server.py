#!/usr/bin/env python3
from fastapi import FastAPI
from pathlib import Path
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer
import json

app = FastAPI(title="MCP RAG Server")

MODEL_NAME = "all-MiniLM-L6-v2"
MODEL = SentenceTransformer(MODEL_NAME)

INDEX_FILE = Path("/var/lib/mcp-rag/index.faiss")
META_FILE = Path("/var/lib/mcp-rag/docs.json")
DOC_ROOT = Path("/home/oli/together")

@app.post("/build_index")
def build_index():
    docs = []
    texts = []
    for f in DOC_ROOT.glob("**/*"):
        if f.is_file():
            try:
                t = f.read_text(errors="ignore")
                if t.strip():
                    docs.append(str(f))
                    texts.append(t)
            except Exception:
                pass
    if not texts:
        return {"status": "no_docs"}

    embeddings = MODEL.encode(texts, convert_to_numpy=True, show_progress_bar=False)
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    index.add(embeddings)
    INDEX_FILE.parent.mkdir(parents=True, exist_ok=True)
    faiss.write_index(index, str(INDEX_FILE))
    META_FILE.write_text(json.dumps(docs, ensure_ascii=False, indent=2))
    return {"status": "ok", "docs": len(docs)}

@app.get("/query")
def query(q: str, k: int = 3):
    if not INDEX_FILE.exists() or not META_FILE.exists():
        return {"error": "no_index"}
    index = faiss.read_index(str(INDEX_FILE))
    docs = json.loads(META_FILE.read_text())
    q_emb = MODEL.encode([q], convert_to_numpy=True)
    D, I = index.search(q_emb, k)
    results = []
    for idx in I[0]:
        if 0 <= idx < len(docs):
            p = Path(docs[idx])
            try:
                results.append({"path": str(p), "content": p.read_text(errors="ignore")})
            except Exception:
                pass
    return {"results": results}
