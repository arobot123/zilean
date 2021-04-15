"use strict";

//sudo npm install request
const request = require('request');
//sudo npm install cheerio
let cheerio = require('cheerio');

const patternIp = /^\d{3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
const sites = {
               // github 加速站
               // key: site url; value: site url on www.ipaddress.com
               "github.com": "https://github.com.ipaddress.com",
               "assets-cdn.github.com": "https://github.com.ipaddress.com/assets-cdn.github.com",
               "github.global.ssl.fastly.net": "https://fastly.net.ipaddress.com/github.global.ssl.fastly.net",
               "gist.github.com": "https://github.com.ipaddress.com/gist.github.com",
               "raw.githubusercontent.com": "https://githubusercontent.com.ipaddress.com/raw.githubusercontent.com"
              };

for (let site in sites) {
    request(sites[site], function (error, response, body) {
        //console.log('body:', body);
        //console.log('statusCode:', response.statusCode);
        //console.log(error);
        if (!error) {
            let content = cheerio.load(body);
            let t = content('html').find('td');
            let t2 = t.nextAll();
            let result;

            t2.each(function(i, elem) {
                result = content(this).text();
                if (patternIp.test(result)) {
                    console.log(result + " " + site);
                }
            });
        }
    });
}
