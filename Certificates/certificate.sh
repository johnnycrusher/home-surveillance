#!/usr/bin/env bash

# A basic Self Signed SSL Certificate utility
# by Andrea Giammarchi @WebReflection

# https://www.webreflection.co.uk/blog/2015/08/08/bringing-ssl-to-your-private-network

# # to make it executable and use it
# $ chmod +x certificate
# $ ./certificate # to read the how-to

about() {
  echo "/C=LN/ST=Intranet/L=Local/O=Local\\ Network/OU=Network/CN=${1}/emailAddress=local@network"
}

android_generation() {
  local server=$1
  openssl x509 \
    -in "${server}.crt" \
    -outform DER \
    -out "${server}.der"
}

check() {
  local server=$1
  local when=$(openssl x509 -in "${server}.crt" -noout -enddate)
  icho "Expires in [*]${when:9}[/]"
}

create() {
  local server=$1
  local subj=$(about $server)
  local CA="${server}CA"
  echo ''
  echo '-----------------------------'
  icho '   [*]generating certificate[/]'
  echo '-----------------------------'
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -subj "${subj}" \
    -keyout "${server}.key" \
    -out "${server}.crt" \
    -reqexts v3_req \
    -extensions v3_ca
  android_generation "${server}"
  echo '-----------------------------'
  icho "[g]OK[/] [*]$(check $server)[/]"
  echo ''
}

update() {
  local server=$1
  local subj=$(about $server)
  echo ''
  echo '-----------------------------'
  icho '    [*]updating certificate[/]'
  echo '-----------------------------'
  echo $(check $server)
  cp "${server}.crt" "${server}.crt.bck"
  cp "${server}.der" "${server}.der.bck"
  cp "${server}.key" "${server}.key.bck"
  openssl req -x509 -nodes -new -days 365 \
    -subj "${subj}" \
    -key "${server}.key" \
    -out "${server}.crt" \
    -reqexts v3_req \
    -extensions v3_ca
  android_generation "${server}"
  echo '-----------------------------'
  icho "[g]OK[/] [*]$(check $server)[/]"
  echo ''
}

isCertificateThere() {
  if [ ! -f "${1}.crt" ]; then
    icho ' [*][r][Warning][/] you need to create a certificate first'
    icho "  example: [*]certificate create ${1}[/]"
    echo ''
    exit 1
  fi
}

# slightly enriched echo
# - - - - - - - - - - - - - -
#        by Andrea Giammarchi
icho() {

  # resets
  local reset_all=$(tput sgr0)        # [/] usable as reset for each style
  local reset_color=$(tput setaf 9)   # [/(d|r|g|y|b|m|c|w)]
  local reset_bgcolor=$(tput setab 9) # [/(bd|br|bg|by|bb|bm|bc|bw)]
  local reset_underline=$(tput rmul)  # [/_]

  # colors
  local black=$(tput setaf 0)         # [d]dark[/d]
  local red=$(tput setaf 1)           # [r]red[/r]
  local green=$(tput setaf 2)         # [g]green[/g]
  local yellow=$(tput setaf 3)        # [y]yellow[/y]
  local blue=$(tput setaf 4)          # [b]blue[/b]
  local magenta=$(tput setaf 5)       # [m]magenta[/m]
  local cyan=$(tput setaf 6)          # [c]cyan[/c]
  local white=$(tput setaf 7)         # [w]white[/w]

  # background colors
  local bgblack=$(tput setab 0)       # [bd]bg dark[/bd]
  local bgred=$(tput setab 1)         # [br]bg red[/br]
  local bggreen=$(tput setab 2)       # [bg]bg green[/bg]
  local bgyellow=$(tput setab 3)      # [by]bg yellow[/by]
  local bgblue=$(tput setab 4)        # [bb]bg blue[/bb]
  local bgmagenta=$(tput setab 5)     # [bm]bg magenta[/bm]
  local bgcyan=$(tput setab 6)        # [bc]bg cyan[/bc]
  local bgwhite=$(tput setab 7)       # [bw]bg white[/bw]

  # styles
  local start_under=$(tput smul)      # [_][/_]
  local start_bold=$(tput bold)       # [*][/*]
                                      # [*][/]

  # not implemented
  # rev Start reverse video
  # blink Start blinking text
  # invis Start invisible text
  # smso  Start "standout" mode
  # rmso  End "standout" mode

  # phrase replacement
  local phrase=$(echo "${1}" |
    sed -e "s/\[\*\]/\\${start_bold}/g" | sed -e "s/\[\/\*\]/\\${reset_all}/g" |
    sed -e "s/\[_\]/\\${start_under}/g" | sed -e "s/\[\/_\]/\\${reset_underline}/g" |
    sed -e "s/\[d\]/\\${black}/g" | sed -e "s/\[\/d\]/\\${reset_color}/g" |
    sed -e "s/\[r\]/\\${red}/g" | sed -e "s/\[\/r\]/\\${reset_color}/g" |
    sed -e "s/\[g\]/\\${green}/g" | sed -e "s/\[\/g\]/\\${reset_color}/g" |
    sed -e "s/\[y\]/\\${yellow}/g" | sed -e "s/\[\/y\]/\\${reset_color}/g" |
    sed -e "s/\[b\]/\\${blue}/g" | sed -e "s/\[\/b\]/\\${reset_color}/g" |
    sed -e "s/\[m\]/\\${magenta}/g" | sed -e "s/\[\/m\]/\\${reset_color}/g" |
    sed -e "s/\[c\]/\\${cyan}/g" | sed -e "s/\[\/c\]/\\${reset_color}/g" |
    sed -e "s/\[w\]/\\${white}/g" | sed -e "s/\[\/w\]/\\${reset_color}/g" |
    sed -e "s/\[bd\]/\\${bgblack}/g" | sed -e "s/\[\/bd\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[br\]/\\${bgred}/g" | sed -e "s/\[\/br\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[bg\]/\\${bggreen}/g" | sed -e "s/\[\/bg\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[by\]/\\${bgyellow}/g" | sed -e "s/\[\/by\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[bb\]/\\${bgblue}/g" | sed -e "s/\[\/bb\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[bm\]/\\${bgmagenta}/g" | sed -e "s/\[\/bm\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[bc\]/\\${bgcyan}/g" | sed -e "s/\[\/bc\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[bw\]/\\${bgwhite}/g" | sed -e "s/\[\/bw\]/\\${reset_bgcolor}/g" |
    sed -e "s/\[\/\]/\\${reset_all}/g"
  )
  echo -e "${phrase}${reset_all}"
}

echo ''
case $1 in
  check)
    isCertificateThere $2
    check $2
  ;;
  clean)
    isCertificateThere $2
    rm -f ${2}.{crt,der,key}.bck
    icho 'all [*]clean[/]'
  ;;
  create)
    create $2
  ;;
  test)
    isCertificateThere $2
    icho '- - - - - - - - - - - [*]visit[/]'
    node -e "'use strict';
var
  fs = require('fs'),
  server = '${2}',
  port = parseInt('${3}' || 8080, 10),
  onSW = function (res) {
    res.writeHead(200, {'Content-Type':'application/javascript'});
    res.end();
  },
  script = ''.concat(
    '<script>try{navigator.serviceWorker.register(\"/sw.js\").then(',
      function () {
        document.body.appendChild(
          document.createElement(\"p\")
        ).innerHTML = 'Service Worker is <strong>supported</strong>';
      },
    ').catch(',
      function () {
        document.body.appendChild(
          document.createElement(\"p\")
        ).innerHTML = 'Service Worker is <strong>NOT supported</strong>';
      },
    ')}catch(e){',
      'document.body.appendChild(',
        'document.createElement(\"p\")',
      ').innerHTML=\"This browser has no Service Worker\"',
    '}</script>'
  )
;

require('https')
  .createServer({
    key: fs.readFileSync(server + '.key'),
    cert: fs.readFileSync(server + '.crt')
  },
  function (req, res) {
    if (req.url=='/sw.js') return onSW(res);
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('<!DOCTYPE html>'.concat(
      '<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\">',
      '<style>*{font-family:sans-serif;}</style>',
      '<strong><span style=\"color:green;\">&#10004;</span> Hello HTTPS</strong>',
      script
    ));
  }
).listen(port, server, showInfo);
require('http')
  .createServer(
  function (req, res) {
    switch (req.url) {
      case ('/sw.js'):
        onSW(res);
        break;
      case ('/' + server + '.crt'):
      case ('/' + server + '.der'):
        res.writeHead(200, {'Content-Type': 'application/x-x509-ca-cert'});
        fs.createReadStream(req.url.slice(1)).pipe(res);
        break;
      default:
        res.writeHead(200);
        res.end('<!DOCTYPE html>'.concat(
          '<meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\">',
          '<style>*{font-family:sans-serif;}a{line-height:42px;}li{margin-bottom:36px;}</style>',
          '<ul>',
            '<li><a href=\"/', server, '.crt\">download ', server, '.crt</a><br/><small>iOS, Windows Phone and Desktop</small></li>',
            '<li><a href=\"/', server, '.der\">download ', server, '.der</a><br/><small>Blackberry and maybe Android</small></li>',
            '<li><a href=\"https://', server, ':', port, '/\" style=\"font-size:small;\">try https</a></li>',
          '</ul>',
          script
        ));
        break;
    }
  }
).listen(port + 1, server, showInfo);
function showInfo() {
  var
    addres = this.address(),
    isHTTPS = addres.port == port,
    prefix = isHTTPS ?
      'HTTPS                 https' :
      'Download Certificate  http'
  ;
  console.log(prefix + '://' + addres.address + ':' + addres.port + '/');
}"
  ;;
  update)
    isCertificateThere $2
    update $2
  ;;
  *)
    icho "
 [*][About][/]
 a basic Self Signed SSL Certificate utility
         by Andrea Giammarchi @WebReflection

 [*][Usage][/]
 ./certificate [check|create|test|update] servername|ip [port]

 [*][Examples][/]

  # [*]create[/] a new certificate
  ./certificate create 192.168.1.10

  # [*]verify[/] its expiring date
  ./certificate check 192.168.1.10

  # [*]update[/] its expiring date
  certificate update 192.168.1.10

  # [*]create[/] both http and https pages
  # one to download the right certificate
  # the other one to test the page
  ./certificate test 192.168.1.10 1337

"
  ;;
esac
echo ''