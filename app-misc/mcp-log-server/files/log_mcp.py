#!/usr/bin/env python3
from fastapi import FastAPI
from pathlib import Path
import subprocess
import json

app = FastAPI(title="MCP Log Server")

LOG_DIR = Path("/var/log")
ETC_WHITELIST = Path("/usr/libexec/mcp-log-server/allowed_paths.json")

def allowed_etc(path: Path) -> bool:
    try:
        allowed = json.loads(ETC_WHITELIST.read_text())
        return any(str(path).startswith(p) for p in allowed)
    except Exception:
        return False

@app.get("/logs")
def list_logs():
    return [str(p) for p in LOG_DIR.glob("**/*") if p.is_file()]

@app.get("/read_log")
def read_log(path: str):
    p = (LOG_DIR / path).resolve()
    if not str(p).startswith(str(LOG_DIR)):
        return {"error": "path escape"}
    try:
        return {"content": p.read_text(errors="ignore")}
    except Exception as e:
        return {"error": str(e)}

@app.get("/etc")
def read_etc(path: str):
    p = Path("/etc") / path
    p = p.resolve()
    if not allowed_etc(p):
        return {"error": "not allowed"}
    try:
        return {"content": p.read_text(errors="ignore")}
    except Exception as e:
        return {"error": str(e)}

@app.get("/journal")
def journal(unit: str = None, lines: int = 200):
    cmd = ["journalctl", "-n", str(lines), "--no-pager"]
    if unit:
        cmd += ["-u", unit]
    try:
        out = subprocess.check_output(cmd, text=True)
        return {"output": out}
    except Exception as e:
        return {"error": str(e)}

@app.get("/dmesg")
def dmesg():
    try:
        out = subprocess.check_output(["dmesg"], text=True)
        return {"output": out}
    except Exception as e:
        return {"error": str(e)}
