class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://github.com/msharov/snownews"
  url "https://github.com/msharov/snownews/archive/v1.8.tar.gz"
  sha256 "90d2611b3e3a00bc14a8869365d366ad1dab17ea1687857440159fc7137c3bed"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_big_sur: "8f6543fe8c6e40ec9e04b38178d1945fc3f80141f9c1035235232771807c04de"
    sha256 big_sur:       "4b9252e14c89712ad72b1c4e52d467ef36ec0f8a53b15083f11120dade87f7a0"
    sha256 catalina:      "6829a661dc7dbd01b149a05aff6b81b4ecc22b99f3f06345f029b183bf952c64"
    sha256 mojave:        "db1d20c1468867a2eeb77b521fdfac4e167393797506afd6bbd603fb40c435bf"
    sha256 high_sierra:   "0e1eed435b2c94a95e35ee89c3b68be6cfa9867d75dc9fbb46b19a66ff6da915"
    sha256 sierra:        "6437a67fb63f92f3c4d57b69505cb5146e2d7325da0d6fd73b57ac0f1461c807"
    sha256 x86_64_linux:  "1bc8d2f7190394e31ed0f131f695ce8a5deef0db9f7c34e4a1469e9b3d33a974"
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
