from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "FastAPI Microservice V2.0.0. Success!"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
