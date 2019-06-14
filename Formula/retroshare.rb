class Retroshare < Formula
  desc "Friend to friend communication platform"
  homepage "https://retroshare.cc/"
  url "https://github.com/RetroShare/RetroShare/releases/download/v0.6.5/RetroShare-v0.6.5-source-with-submodules.tar.gz"
  sha256 "d974d25cbcceccaf6e23e3b8d683d61e91b08c1853b3be0ecb06281809979cb3"
  head "https://github.com/RetroShare/RetroShare.git"

  depends_on "pkg-config" => :build
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "qt"
  depends_on "rapidjson"
  depends_on "sqlcipher"
  depends_on "xapian"

  def install
    # Avoid RetroShare build system set wrong SDK version
    inreplace "retroshare.pri",
        "macx:CONFIG *= rs_macos10.11", ""
    inreplace "retroshare-gui/src/retroshare-gui.pro",
        "	target.path = \"$${BIN_DIR}\"",
        "	target.path=#{prefix}"
    system "qmake",
        "PREFIX=#{prefix}",
        "CONFIG+=c++11", "CONFIG+=no_retroshare_nogui", "CONFIG+=no_libresapi",
        "CONFIG+=no_libresapihttpserver", "CONFIG+=rs_deep_search",
        "RS_MAJOR_VERSION=0", "RS_MINOR_VERSION=6", "RS_MINI_VERSION=5",
        "RS_EXTRA_VERSION=-macOS-#{MacOS.version}-homebrew",
        "INCLUDEPATH+=#{Formula["miniupnpc"].opt_include}",
        "INCLUDEPATH+=#{Formula["openssl"].opt_include}",
        "INCLUDEPATH+=#{Formula["rapidjson"].opt_include}",
        "INCLUDEPATH+=#{Formula["sqlcipher"].opt_include}",
        "INCLUDEPATH+=#{Formula["xapian"].opt_include}",
        "QMAKE_LIBDIR+=#{Formula["miniupnpc"].opt_lib}",
        "QMAKE_LIBDIR+=#{Formula["openssl"].opt_lib}",
        "QMAKE_LIBDIR+=#{Formula["rapidjson"].opt_lib}",
        "QMAKE_LIBDIR+=#{Formula["sqlcipher"].opt_lib}",
        "QMAKE_LIBDIR+=#{Formula["xapian"].opt_lib}",
        "DATA_DIR=#{share}"
    system "make"
    system "make", "install"
    bin.install_symlink "#{prefix}/retroshare.app/Contents/MacOS/retroshare"
  end

  test do
    puts shell_output("find #{prefix}")
  end
end
