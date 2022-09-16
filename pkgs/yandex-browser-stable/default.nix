{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, flac
, gnome2
, harfbuzzFull
, nss
, snappy
, xdg-utils
, xorg
, alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libdrm
, libnotify
, libopus
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, pango
, systemd
, at-spi2-atk
, at-spi2-core
}:

stdenv.mkDerivation rec {
  pname = "yandex-browser";
  version = "22.7.5.1034-1";

  src = fetchurl {
    url = "http://repo.yandex.ru/yandex-browser/deb/pool/main/y/${pname}-stable/${pname}-stable_${version}_amd64.deb";
    sha256 = "8fd606608c8735775ac6a0295a1b8963413ec47613737a81a281db5ef2f216c3";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    flac
    harfbuzzFull
    nss
    snappy
    xdg-utils
    xorg.libxkbfile
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libnotify
    libopus
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    mkdir $TMP/ya/ $out/bin/ -p
    ar vx $src
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/ya/
  '';

  installPhase = ''
    cp $TMP/ya/{usr/share,opt} $out/ -R
    substituteInPlace $out/share/applications/yandex-browser.desktop --replace /usr/ $out/
    ln -sf $out/opt/yandex/browser/yandex_browser $out/bin/yandex-browser
  '';

  runtimeDependencies = map lib.getLib [
    libpulseaudio
    curl
    systemd
  ] ++ buildInputs;

  meta = with lib; {
    description = "Yandex Web Browser";
    homepage = "https://browser.yandex.ru/";
    license = licenses.unfree;
    maintainers = with maintainers; [ devrtc0 ];
    platforms = [ "x86_64-linux" ];
  };
}
