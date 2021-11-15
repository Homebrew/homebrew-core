class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/msharov/snownews"
  url "https://github.com/msharov/snownews/archive/v1.9.tar.gz"
  sha256 "d8ef0c7ef779771e2c8322231bdfa7246d495ba8f24c3c210c96f3b6bd3776a7"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_monterey: "f3f130a39bd4c89ba0c1315cc94bd631dcbcfb6de37670b5beefb12262d18c39"
    sha256 arm64_big_sur:  "e33470f154aa0ac91be4e22fc07fbe038109fe6e528f024b1886a21c09cb118d"
    sha256 monterey:       "0df289333512883cc93e2c314575f73f7a0d4099b67299f8942daf22611ba9f4"
    sha256 big_sur:        "ae91430f56cf66c0c9926bef6b0bd2134e68730cfacac0db1dd8456a976a53f7"
    sha256 catalina:       "bd3a4094a8b1e6a5ea21d0d1f3215d9b97480600b41b72278ca492f1b36ffd9c"
    sha256 mojave:         "47d68cd32e932522a59536319a6dc56717925d15a137924c0a5ff374b12b2223"
    sha256 x86_64_linux:   "d9e3e43ead0b9f28bf3967c7c7c4da67264429171125a04fa44dad43c7aa5369"
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # remove in next release
  patch do
    url "https://github.com/msharov/snownews/commit/a43c1811c2bd2921b7e44fd4b28b852915b45072.patch?full_index=1"
    sha256 "cd64cd6d9493019496b100a71a8e6c10f33b63fb3d29b7863434bc2eee7cdd00"
  end

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_symptoms.dylib and
    # /usr/lib/system/libsystem_darwin.dylib on 10.11 and 10.12, respectively
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    system "./configure", "--prefix=#{prefix}"

    # Must supply -lz because configure relies on "xml2-config --libs"
    # for it, which doesn't work on OS X prior to 10.11
    system "make", "install", "EXTRA_LDFLAGS=#{ENV.ldflags} -L#{Formula["openssl@1.1"].opt_lib} -lz",
           "CC=#{ENV.cc}", "INSTALL=ginstall"
  end

  test do
    assert_match version.to_s, shell_output(bin/"snownews --help")
  end
end
