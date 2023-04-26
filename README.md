## Build container
```
# for pushing to ghcr
docker buildx build --platform=linux/x86_64 --push -t ghcr.io/aflansburg/coduoserver .
# for local (use --load)
docker buildx build --platform=linux/x86_64 --load -t coduoserver .
```

## Deployment
So many options.

### Good on demand type options
- Google Cloud Run
- AWS ECS

Could also run the container locally and expose the port over an ngrok secure tunnel.

