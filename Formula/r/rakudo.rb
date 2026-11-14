class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.11/rakudo-2026.11.tar.gz"
  sha256 "02f71c340e943163de524ed4ea3c872143ca03a907a11326d54f2d150789ab43"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "49c3bc609bf21e519d9ad09bd6edcf945d20503566406d0c134aa60c3aedcf5c"
    sha256 arm64_tahoe:       "3081eda44e8a34fba65b85a6546bc47db90c67f8618a6da817af0025db275e00"
    sha256 arm64_sequoia:     "e2990c8f4151b2b527666483dc9c3c157dcde00b4f086800101f187ff766259a"
    sha256 arm64_linux:       "9c8052458e759781ad604d1e271af9370f3cc06e5032322bdfce11ffb7c2fb76"
    sha256 x86_64_linux:      "c734f42c2b5fa41d63ec68b13749cafc476ede76f4843fd4be811bf168fed274"
  end

  depends_on "moarvm"
  depends_on "nqp"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{formula_opt_bin("nqp")}/nqp"

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
