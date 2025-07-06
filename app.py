from flask import Flask
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app, path="/metrics")

@app.route("/")
def home():
    return "Welcome to the Cloud Engineer’s Playground! 😎🚀"

# explicitly expose metrics
@app.route("/metrics")
def metrics_route():
    return metrics.do_export()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)