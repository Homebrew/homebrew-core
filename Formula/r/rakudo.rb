class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.12/rakudo-2025.12.tar.gz"
  sha256 "6c2a3ee2b1a4336d19e20976f616ea49c99a10b24e0c218ca47e6bac41f4f484"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3f33984fbff7658307fe2ec097438960eec1115ea1dde4f94fffd8086cc9cfd9"
    sha256 arm64_sequoia: "0a800597b122392a6dde62c4db995c5f77c844d15077a27910c6b0fb259815d5"
    sha256 arm64_sonoma:  "bd19b1bad4f3f2569230354a4c95a72e4145d8b9c5eb39b93dba6ab67c25829f"
    sha256 sonoma:        "0520efc1ac38bdb7d7fc23c6b0722d8dc6700f74e797b5329723b9cf0a92898a"
    sha256 arm64_linux:   "011a07558f6e781d7e5c7552d090bedc22909bcdb5b4d1ec566b238d173df2c7"
    sha256 x86_64_linux:  "43ad2562ffeb742a2accc95709b564910b4dd0fad02fa6f62a3ac9a6f12b6907"
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
