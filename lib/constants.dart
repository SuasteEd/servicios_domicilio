// $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
// $headers.Add("Authorization", "key=AAAAzTMwAns:APA91bFOj5XVlXHfPTRJShZtrjWAQtHT9rUJ30lkQklKv4f4-jlVr_A80Mm--FrTUMwptunwKA0FHIcQp-AQZevau3khEGAlKGr0Y_rC-BuWAW7HhvAOZNWKo3q1-3WrQ7tSq2tUJYND")
// $headers.Add("Content-Type", "application/json")

// $body = "{
// `n    `"to`": `"dvWYnlY1RPGQ8jlXVFJDIq:APA91bGGADvh6YLE7MMwbUNwj7Q_oVt5lqw6TXITAaLNExq-w-EZ7muQdg1NeozWM2tz2IOLfjDTkqDy1JcCTZQIGABK9UpKANkiHXwNVM_6HddHLoeyc1dsSJkaJHw1cYjHeJWz_Dc-`",
// `n    `"notification`": {
// `n        `"title`": `"¡NUEVO SERVICIO ASIGNADO!`",
// `n        `"body`": `"PRUEBAA`"
// `n        `"data`": ``
// `n    }
// `n}"

// $response = Invoke-RestMethod 'https://fcm.googleapis.com/fcm/send' -Method 'POST' -Headers $headers -Body $body
// $response | ConvertTo-Json