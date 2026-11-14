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
    sha256 arm64_golden_gate: "0505d4919a6784687ad78a176e2e493fb1576da5872fa1768284f7a3a5eeca9d"
    sha256 arm64_tahoe:       "d8ee72c281cd330ae6e8af5d3587a17e7cb2cc8d7c6888a2fc4718ad5eb46095"
    sha256 arm64_sequoia:     "f5d538b5e6c45f5076ef04b326f2bebad1a9871cec0dc139c22cdd6d9f64c200"
    sha256 arm64_linux:       "3a988f803803a689833f1610902334001d1f1a53df5a58af903c0090208dac6f"
    sha256 x86_64_linux:      "7287b9adcab645dbd24542d8472862b021b7c1f94463ce8dccc9d80a7e6504b7"
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
