echo
echo ----------------------------------------------------
curl -X POST "http://localhost:4567/events" -H "Content-Type: application/json" -d '{"data":"NAME is now at LATITUDE/LONGITUDE"}'
echo ----------------------------------------------------
PAUSE
echo
echo
echo ----------------------------------------------------
curl "http://localhost:4567/events"
echo ----------------------------------------------------
PAUSE
echo ----------------------------------------------------
curl -X DELETE "http://localhost:4567/events"
echo ----------------------------------------------------
PAUSE
curl "http://localhost:4567/events/2"
PAUSE
curl -X POST "http://localhost:4567/events/2" -H "Content-Type: application/json" -d '{"data":"NAME is now at LATITUDE/LONGITUDE"}'
PAUSE
curl -X DELETE "http://localhost:4567/events/2"