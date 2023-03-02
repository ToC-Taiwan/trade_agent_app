# CHANGELOG

## [v5.0.0](https://github.com/ToC-Taiwan/trade_agent_app/compare/v4.2.0...v5.0.0)

> 2023-03-02

### Code Refactoring (1)

* **dart:** refactor most layout in new lint rule, move all data class to entity

### Features (1)

* **traderate:** modify calculate method, and style of trade rate

## v4.2.0

> 2022-12-10

### Bug Fixes (17)

* **android:** try modify AndroidManifest.xml
* **api:** add all try catch in fetch data, add all no data text, loding circle modify
* **balance:** fix wrong color in stock page
* **dayKbar:** fix duplicate data, fix wrong icon color, add kdebug mode for ad
* **font:** fix assisting font size oversize, order result has float
* **hook:** fix missing add pubspec.yaml
* **hook:** fix missing upload pre-commit hook
* **iap:** add check if remove_ad_status exist
* **iap:** modify restore button text
* **iap:** modify spell of restore purchases
* **kbar:** fix wrong route, add refresh button, add content for settings
* **pubspec:** fix missing upload pubspec
* **strategy:** fix duplicate insert pickstock, modify tiny layout
* **trade:** fix wrong first tick time of future trade
* **tse:** fix wrong sequence
* **version:** fix wrong version build
* **version:** fix wrong version

### Features (52)

* change app icon
* **ad:** add SKAdNetworkItems, modify restore button
* **ad:** change usual banner to adaptive banner
* **ad:** update app id for android v2
* **animation:** remove intro to homepage animation
* **api:** transfer to tmt api
* **balance:** split stock, future balance to different tab
* **balance:** modify layout, remove url launcher in targets
* **balance:** change scaffold background to white, new balance page
* **chart:** add new candle chart in future trade
* **config:** modify trade config class member, add buy sell i10n
* **dependency:** update dependency
* **dependency:** update dependency, remove changelog
* **entitlement:** add entitlement for push notification
* **firebase:** add firebase core, fix floor import
* **future:** add wake lock in future trade, add i10n in future trade
* **future:** add future realtime tick, future trade balance
* **future:** add multiple websocket data in future trade
* **https:** recover http packge to http from dart:io
* **https:** change from http to dart:io client to https, add v1 url
* **iap:** modify restore purchase button
* **iap:** add iap for remove ad
* **intro:** change intro animate to loading, add clear button to search
* **kbar:** add display button and no animation route, add target to kbar tap
* **kbar:** fork candlestick and change red between green
* **kbar:** add kbar template
* **kbar:** add check candle length for 30
* **kbar:** update fork candlestick color to light green and red
* **language:** add change language function
* **layout:** add pickstock page, add basic db, add new settings page
* **layout:** migrate from old project, only files
* **layout:** remove setting page from bottom, add strategy page, modify balance, tse
* **loading:** add loading text when no network
* **migrate:** update appid finish migrate
* **migration:** make sure migration work
* **newpage:** add pick stock page, let main layout has own appbar, fix all warning
* **order:** add order page, modify future trade notification, add assist temp
* **settings:** add restore purchase button
* **settings:** finish settings page, all page has db instance, remove some content in settings
* **strategy:** add new page strategy, intro
* **strategy:** change from list to calendar, and add pickstock from strategy
* **target:** add url_launcher, auto size text, curved bar, target change to grid
* **target:** modify target card layout
* **terms:** remove terms of use
* **trade:** move calculate trade rate to mobile
* **trade:** improve permance of future trade, reverse orders, remove db future qty
* **trade:** change json to proto in ws, add assist in trade, recalculate balance
* **tse:** add i10n in tse, add refresh button
* **url:** change deprecated api in url_launcher, update pod file
* **version:** load version from pubspec, remove old pre-commit hook
* **websocket:** add check connection and reconnect when mounted, remove realtime futuretick sqlite
* **ws:** refactor ws reconnect method, change default content before connected
