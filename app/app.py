from flask import Flask, jsonify
import os

app = Flask(__name__)

VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def home():
    return jsonify({
        "application": "NovaPay Digital Bank",
        "version": VERSION,
        "status": "running"
    })


@app.get("/health")
def health():
    return jsonify({
        "status": "healthy",
        "version": VERSION
    }), 200


@app.get("/version")
def version():
    return jsonify({
        "version": VERSION
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)  # nosec B104 - required for container networking
