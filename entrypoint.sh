#!/usr/bin/env bash
set -e
set -o pipefail

blow_up() {
	echo "Missing required enviroment variable '$1'. Please, take a look at the manual." >&2
	exit 1
}
[ "$API_URL" ] || blow_up 'API_URL'
[ "$MAP_LAT" ] || blow_up 'MAP_LAT'
[ "$MAP_LNG" ] || blow_up 'MAP_LNG'
[ "$MAP_ZOOM" ] || blow_up 'MAP_ZOOM'

if [ "$DISABLE_PANEL" = true ] ; then
        rm -rf /var/www/zup-painel
else
        sed -i -E "s@(apiEndpoint:')([^']*)?(')@\1$API_URL\3@g" /var/www/zup-painel/config/main.constants.js
        sed -i -E "s@(mapLat:')([^']*)?(')@\1$MAP_LAT\3@g" /var/www/zup-painel/config/main.constants.js
        sed -i -E "s@(mapLng:')([^']*)?(')@\1$MAP_LNG\3@g" /var/www/zup-painel/config/main.constants.js
        sed -i -E "s@(mapZoom:')([^']*)?(')@\1$MAP_ZOOM\3@g" /var/www/zup-painel/config/main.constants.js
        sed -i -E "s@(logoImgUrl:')([^']*)?(')@\1$LOGO_IMG_URL\3@g" /var/www/zup-painel/config/main.constants.js
        sed -i -E "s@(theme:')([^']*)?(')@\1$THEME\3@g" /var/www/zup-painel/config/main.constants.js

        sed -i "s@SENTRY_DSN@$SENTRY_DSN@g" /var/www/zup-painel/index.html
        sed -i "s@GOOGLE_ANALYTICS_KEY@$GOOGLE_ANALYTICS_KEY@g" /var/www/zup-painel/index.html
        sed -i "s@PAGE_TITLE@$PANEL_PAGE_TITLE@g" /var/www/zup-painel/index.html

	[ -d /painel/images ] && cp -R /painel/images/*.* /var/www/zup-painel/assets/images
fi

if [ "$DISABLE_WEB_APP" = true ] ; then
        echo "Web citizen application will not be available."
        rm -rf /var/www/zup-web-cidadao/**/*
        [ "$DISABLE_PANEL" != true ] && echo '<html><head><meta http-equiv="refresh" content="0;URL=/painel" /></head></html>' > /var/www/zup-web-cidadao/index.html
else
        sed -i -E "s@(apiEndpoint:')([^']*)?(')@\1$API_URL\3@g" /var/www/zup-web-cidadao/scripts/constants.js
        sed -i -E "s@(mapLat:')([^']*)?(')@\1$MAP_LAT\3@g" /var/www/zup-web-cidadao/scripts/constants.js
        sed -i -E "s@(mapLng:')([^']*)?(')@\1$MAP_LNG\3@g" /var/www/zup-web-cidadao/scripts/constants.js
        sed -i -E "s@(mapZoom:')([^']*)?(')@\1$MAP_ZOOM\3@g" /var/www/zup-web-cidadao/scripts/constants.js

        sed -i "s@GOOGLE_ANALYTICS_KEY@$GOOGLE_ANALYTICS_KEY@g" /var/www/zup-web-cidadao/index.html

        [ -d /web/images ] && cp -R /web/images/*.* /var/www/zup-web-cidadao/images

        if [ -z "$PAGE_TITLE" ]; then
                sed -i "s@PAGE_TITLE@ZUP Web@g" /var/www/zup-web-cidadao/index.html
        else
                sed -i "s@PAGE_TITLE@$PAGE_TITLE@g" /var/www/zup-web-cidadao/index.html
        fi

        [ -f /web/terms.html ] && TERMS_AND_CONDITIONS_HTML=`cat /web/terms.html`

        if [ -z "$TERMS_AND_CONDITIONS_HTML" ]; then
                sed -i "s@HAS_TERMS_AND_CONDITIONS@none@g" /var/www/zup-web-cidadao/styles/*.main.css
        else
                perl -i -pe "s@TERMS_AND_CONDITIONS_HTML@$TERMS_AND_CONDITIONS_HTML@g" /var/www/zup-web-cidadao/index.html
                perl -i -pe "s@TERMS_AND_CONDITIONS_HTML@$TERMS_AND_CONDITIONS_HTML@g" /var/www/zup-web-cidadao/views/modal_terms_of_use.html
                sed -i "s@HAS_TERMS_AND_CONDITIONS@block@g" /var/www/zup-web-cidadao/styles/*.main.css
        fi
fi

[ "$DEFAULT_CITY" != "" ] && CITY_NAME=$DEFAULT_CITY
if [ "$DISABLE_LANDING_PAGE" = true ] || [ -z "$CITY_NAME" ] ; then
        echo "Landing page will not be available."
        rm -rf /var/www/zup-landing/**/*
        [ "$DISABLE_PANEL" != true ] && echo '<html><head><meta http-equiv="refresh" content="0;URL=/painel" /></head></html>' > /var/www/zup-landing/index.html
else
        sed -i "s@CITY_NAME@$CITY_NAME@g" /var/www/zup-landing/index.html

        [ -d /landing-page/images ] && cp -R /landing-page/images/*.* /var/www/zup-landing/images

        if [ -z "$PAGE_TITLE" ]; then
                sed -i "s@PAGE_TITLE@ZUP@g" /var/www/zup-landing/index.html
        else
                sed -i "s@PAGE_TITLE@$PAGE_TITLE@g" /var/www/zup-landing/index.html
        fi

        if [ -z "$APPLICATION_NAME" ]; then
                sed -i "s@APPLICATION_NAME@ZUP@g" /var/www/zup-landing/index.html
        else
                sed -i "s@APPLICATION_NAME@$APPLICATION_NAME@g" /var/www/zup-landing/index.html
        fi

        sed -i "s@API_URL@$API_URL@g" /var/www/zup-landing/scripts/main.js
        if [ -z "$IOS_APP_LINK" ]; then
                sed -i "s@HAS_IOS_APP_LINK@none@g" /var/www/zup-landing/styles/main.css
        else
                sed -i "s@IOS_APP_LINK@$IOS_APP_LINK@g" /var/www/zup-landing/index.html
                sed -i "s@HAS_IOS_APP_LINK@block@g" /var/www/zup-landing/styles/main.css
        fi

        if [ -z "$ANDROID_APP_LINK" ]; then
                sed -i "s@HAS_ANDROID_APP_LINK@none@g" /var/www/zup-landing/styles/main.css
        else
                sed -i "s@ANDROID_APP_LINK@$ANDROID_APP_LINK@g" /var/www/zup-landing/index.html
                sed -i "s@HAS_ANDROID_APP_LINK@block@g" /var/www/zup-landing/styles/main.css
        fi

        if [ -z "$WEB_APP_LINK" ]; then
                sed -i "s@HAS_WEB_APP_LINK@none@g" /var/www/zup-landing/styles/main.css
        else
                sed -i "s@WEB_APP_LINK@$WEB_APP_LINK@g" /var/www/zup-landing/index.html
                sed -i "s@HAS_WEB_APP_LINK@block@g" /var/www/zup-landing/styles/main.css
        fi

        [ -f /landing-page/terms.html ] && TERMS_AND_CONDITIONS_HTML=`cat /landing-page/terms.html`

        if [ -z "$TERMS_AND_CONDITIONS_HTML" ]; then
                sed -i "s@HAS_TERMS_AND_CONDITIONS@none@g" /var/www/zup-landing/styles/main.css
        else
                perl -i -pe "s@TERMS_AND_CONDITIONS_HTML@$TERMS_AND_CONDITIONS_HTML@g" /var/www/zup-landing/index.html
                sed -i "s@HAS_TERMS_AND_CONDITIONS@block@g" /var/www/zup-landing/styles/main.css
        fi
fi

echo "ZUP-WEB is running."

exec "$@"
