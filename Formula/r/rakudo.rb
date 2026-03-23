class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.02/rakudo-2026.02.tar.gz"
  sha256 "1d9cc55427dfdf39ef088c0f22649f341d11e34b966ef2fa28280c8d94052bf7"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0896f81ef97b3f4959055743aa12b76f84f9099df6f8c3441fe0d2e9939ace0e"
    sha256 arm64_sequoia: "4643cf787291adcc64517e2236988c6bf5c083ab28aae85a744673a59ee450b6"
    sha256 arm64_sonoma:  "a031506e30af798fdc6b171fbce85b2731d65bcc02efccaf1bf356602a1e9c58"
    sha256 sonoma:        "0fc84597767bd6715085d1675a1b18865dfdf7f5dd4a22beb933041d51758d7b"
    sha256 arm64_linux:   "ebc97ea5a9f51c58ee7b39a5c0da568c588a195d7ff58f0885bc3f32fd572281"
    sha256 x86_64_linux:  "30530a76dd51197bbe8769f986a33e41b677b59f0339fa08131ca5161f4bfdd6"
  end

  depends_on "moarvm"
  depends_on "nqp"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"

    # Reduce overlinking on macOS
    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "M_LDFLAGS", "#{s.get_make_var("M_LDFLAGS")} -Wl,-dead_strip_dylibs"
      end
    end

    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
