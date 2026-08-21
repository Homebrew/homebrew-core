class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2026.07/rakudo-2026.07.tar.gz"
  sha256 "7d02e472992dc4be7ad5f0cb9c600c6d7c3cadc777137634a036ddb7f511a747"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2807d90b2136a4c8f37a3819452c6eafe87d0b5e9d837c362d401099488a698a"
    sha256 arm64_sequoia: "f1c5721ad6a3986d3c4098ad2ba627c4bae531c9fb9a21bff29ded59b6dc98a7"
    sha256 arm64_sonoma:  "b0eed82aab472b1716e38940a1951883dd647bb67aa9e31ad619f7714b54f61d"
    sha256 sonoma:        "af1941cc3b0822d32a0a3e2c8bf6bac37f6e78b418f20585d75b6fc1fdc031d3"
    sha256 arm64_linux:   "11ac236e0c4160f2cc54766dfa3f4ab074e24e92bac5cce71a1f7a3ec87fb136"
    sha256 x86_64_linux:  "30cd79c1cee82638557440b64ca40e00791d62495ce2618cdb988ca3ec67dc93"
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
