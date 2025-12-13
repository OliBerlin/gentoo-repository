#!/usr/bin/env python3
from fastapi import FastAPI
from pathlib import Path
from typing import List, Dict, Any

BASE = Path("/home/oli/together").resolve()
app = FastAPI(title="Filesystem MCP Server")

def safe(p: str) -> Path:
    full = (BASE / p).resolve()
    if not str(full).startswith(str(BASE)):
        raise ValueError("Path escape detected")
    return full

@app.get("/list")
def list_files() -> List[str]:
    return [str(p.relative_to(BASE)) for p in BASE.glob("**/*")]

@app.get("/read")
def read_file(path: str) -> Dict[str, Any]:
    try:
        p = safe(path)
    except ValueError as e:
        return {"error": str(e)}
    if not p.exists():
        return {"error": "not found"}
    try:
        return {"path": str(p), "content": p.read_text(errors="ignore")}
    except Exception as e:
        return {"error": str(e)}

@app.post("/write")
def write_file(path: str, content: str) -> Dict[str, Any]:
    try:
        p = safe(path)
    except ValueError as e:
        return {"error": str(e)}
    try:
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content)
        return {"status": "ok", "path": str(p)}
    except Exception as e:
        return {"error": str(e)}

@app.post("/mkdir")
def mkdir(path: str) -> Dict[str, Any]:
    try:
        p = safe(path)
    except ValueError as e:
        return {"error": str(e)}
    try:
        p.mkdir(parents=True, exist_ok=True)
        return {"status": "ok", "path": str(p)}
    except Exception as e:
        return {"error": str(e)}
