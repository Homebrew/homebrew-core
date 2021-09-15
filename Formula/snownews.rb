class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/msharov/snownews"
  url "https://github.com/msharov/snownews/archive/v1.8.tar.gz"
  sha256 "90d2611b3e3a00bc14a8869365d366ad1dab17ea1687857440159fc7137c3bed"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "58660bae76a7e02f32ce9f1898a2084c5ffdf5c0ebf32b9ab247f118017fbc91"
    sha256 big_sur:       "aee8b149b904e87e04fe17646410f880d5950f4c23290f1cc88fe692683a5a96"
    sha256 catalina:      "a2e648ee4c4e7a8887cb2ccdb463ffc5e533695ac2ef41a40969bcb27efc9bf0"
    sha256 mojave:        "572a335a0a5b9ad6593c3624a967748d6afd7b9063041e4b8f55a4cc6eac805e"
    sha256 x86_64_linux:  "79d3a5f582497d91865d44713ace32971c68ebdb08ad9a4893f10148c0bfadd2"
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
    url "https://github.com/msharov/snownews/commit/448f9e20490dfdb9bde2f7c9928e72c89b203397.patch?full_index=1"
    sha256 "0f338f63781637c137e0cb0602008e63a6d01e737de11d7e78a498e99a47c4aa"
  end

  # remove in next release
  # https://github.com/msharov/snownews/pull/65
  patch do
    url "https://github.com/chenrui333/snownews/commit/10a676f5df81d73b38efe8a74d2e8dbb6c003df2.patch?full_index=1"
    sha256 "3e864e4dddae592558ec99d3ca18e488aa683c4ac5655ffc15ce717104b934dc"
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
