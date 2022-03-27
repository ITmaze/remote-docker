FROM debian:stable-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install xterm

RUN apt-get -y install firefox-esr
RUN apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module libpci3 libegl1
RUN apt-get -y install fonts-wqy-microhei
RUN apt-get -y install firefox-esr-l10n-en-gb hunspell-en-au hunspell-en-gb hyphen-en-gb
RUN apt-get -y install webext-ublock-origin

RUN echo >> /etc/firefox-esr/firefox-esr.js
RUN echo '// Set local preferences from Dockerfile' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("app.normandy.first_run", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("browser.warnOnQuit", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("browser.startup.homepage", "about:blank");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("datareporting.policy.firstRunURL", "");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("app.update.enabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("app.update.auto", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.cosmeticAnimations.enabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.scrollbox.smoothScroll", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("image.animation_mode", "none");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("browser.startup.homepage_override.mstone", "ignore");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("intl.accept_languages","en-GB");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("intl.locale.requested","en-GB");' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("ui.prefersReducedMotion", 1);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.cosmeticAnimations.enabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("geo.enabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.telemetry.unified", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.telemetry.enabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.telemetry.reportingpolicy.firstRun", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> /etc/firefox-esr/firefox-esr.js
RUN echo 'pref("toolkit.telemetry.server", "");' >> /etc/firefox-esr/firefox-esr.js

RUN echo 'LANG="en_AU.UTF-8"' > /etc/default/locale
RUN echo 'LANGUAGE="en_AU:en" ' >> /etc/default/locale

RUN useradd -ms /bin/bash docker

RUN ln -s /home/onno/Downloads/ /home/docker/Downloads

USER docker

ENTRYPOINT ["/usr/bin/firefox-esr"]
CMD ["https://www.ecosia.org/"]
