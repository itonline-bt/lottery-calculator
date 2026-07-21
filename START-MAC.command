#!/bin/bash
cd "$(dirname "$0")"
PORT=8777
echo ""
echo "  Lottery Calculator"
echo "  http://localhost:$PORT/index.html"
echo "  Close this window to stop the server."
echo ""
( sleep 1; open "http://localhost:$PORT/index.html" ) &
python3 -m http.server $PORT
