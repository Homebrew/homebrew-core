class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8.1/sipsak-0.9.8.1.tar.gz"
  sha256 "c6faa022cd8c002165875d4aac83b7a2b59194f0491802924117fc6ac980c778"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdeab1f200d7259201cc9b730e4cccc64b1f44bb459ef0b0469dfc326076bd61"
    sha256 cellar: :any,                 arm64_sequoia: "9e6d41d992b086dc75abab233eafc9d363b597fbfaa2cb2521d2c5678442540e"
    sha256 cellar: :any,                 arm64_sonoma:  "ccc07823781b80ffb45f40ed22a221dc578062d370085b8bd07b07ef36b9d42e"
    sha256 cellar: :any,                 sonoma:        "49a1b1e90a910f11f4c722bbb4f0ba1f446ed9d522686a8dc1af8443de87917a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fa8195309fd76ee76e841841efd1ab2380242b2d4a500c54295919bc1fddafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae02bba789b5f786c1326c126a621b4f3e9a2c68e316efcc29498e609c300ba"
  end

  depends_on "openssl@4"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"sipsak", "-V"
  end
end
