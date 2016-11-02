<?php
// simple curl php cli tool


// REQUEST CONFIGURATION START -------------------------------------------------
$url='http://enterurlhere/';
$isPost=false;
$data=[];
// $data=[
//      'username' => 'username',
//      'password' => 'password',
// ];

$host           = '';
$xForwardedFor  = '';//'127.0.0.1';
$userAgent      = 'My UserAgent';
$referer        = 'http://www.example.com/index.php';

$cookie=[];
//$cookie=[
//    'user_session=123456',
//];
$cookieOpt= implode(';', $cookie);

// authentification
$useAuth=false;
$username='user';
$password='pass';

// REQUEST CONFIGURATION END ---------------------------------------------------

$headers = [
    'Accept: */*',
    'Accept-Encoding: none',
    'Accept-Language: en-US,en;q=0.5',
    'Cache-Control: no-cache'
];

if ($host !==''){
    $headers[]='Host: '.$host;
}
if ($xForwardedFor != ''){
    $headers[]='X-Forwarded-For: '.$xForwardedFor;
}
if ($userAgent !== ''){
    $headers[]='User-Agent: '.$userAgent;
}
if ($referer !== ''){
    $headers[]='Referer: '.$referer;
}

$ch = curl_init();
if($isPost){
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
} else {
    if (count($data) > 0 ){
        $url = $url. (strpos($url, '?') === FALSE ? '?' : ''). http_build_query($data);
    }
}
if ($useAuth){
    curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
    curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
}

if($cookieOpt){
    curl_setopt($ch, CURLOPT_COOKIE, $cookieOpt);
}

curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLINFO_HEADER_OUT, true);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

$response = curl_exec($ch);
$headerSent = curl_getinfo($ch, CURLINFO_HEADER_OUT );
$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$header = substr($response, 0, $header_size);
$body = substr($response, $header_size);

curl_close($ch);

// PRINT
print "URL : $url \n";
print "Headers : $headerSent";
print "---\n";
print "curl header response is: \n" . $header;
