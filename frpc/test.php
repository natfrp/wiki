<?php

// create today's cache file
$cache_file = "abusedcache-" . date("Y-m-d") . ".json";

// check cache.json for the last time the cache was updated
if (file_exists($cache_file)) {
    // Don't bother refreshing, just use the file as-is.
    $file = file_get_contents($cache_file);
    echo $file;
} else {
    // curl from ipabusedb
    // curl -G https://api.abuseipdb.com/api/v2/blacklist -d confidenceMinimum=50 -d limit=9999999 -d ipVersion=4 -H "Key: $YOUR_API_KEY" -H "Accept: application/json"
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => "https://api.abuseipdb.com/api/v2/blacklist",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "GET",
        CURLOPT_POSTFIELDS => "confidenceMinimum=50&limit=9999999&ipVersion=4",
        CURLOPT_HTTPHEADER => array(
            "Accept: application/json",
            "Key: $YOUR_API_KEY"
        ),
    ));
    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);
    if ($err) {
        echo "cURL Error";
    } else {
        $file = $response;
        file_put_contents($cache_file, $file);
    }
 }

// print minimized json
echo $file;