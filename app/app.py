import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return (
        "<h1>Cloud Status Board</h1>"
        "<p>Junior DevOps pet project is alive.</p>"
        "<p><a href='/health'>/health</a></p>"
    )


@app.get("/health")
def health():
    return jsonify(
        status="ok",
        service="status-board",
        env=os.getenv("APP_ENV", "local"),
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)