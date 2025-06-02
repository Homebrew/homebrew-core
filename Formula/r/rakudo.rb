class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.05/rakudo-2025.05.tar.gz"
  sha256 "8dcfe832801aab6c45de07c053c3ce528cc9b0fb0d3c89143e0602346c62a210"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "5e193601af57f8038d8d16c7587d803b2bb010c41c3cc05eb29d5538bdd53120"
    sha256 arm64_sonoma:  "018a3f47de8d34dc43c6813459b5d1a8c22daed7f06eac0fd8bd93aa152bb8ed"
    sha256 arm64_ventura: "daf836a9ec00e2f0513a76ad6e8db1c081e525c22b45c013276c22e488a7b8cc"
    sha256 sonoma:        "b9b65bd488486ac1b9ea0a68cc1d2eefa7c83dc0cb9164e7f5b3df622af7f859"
    sha256 ventura:       "a4c62efc8d1ab2d3421a000f53aa8dacf88a3c41477e24b8a1e6fb26c879f71c"
    sha256 arm64_linux:   "33c9c2bd481163588190647ad68e11e7fad517edcdd2044d1067e12fc4aa649c"
    sha256 x86_64_linux:  "5968786d431fc2667a8c4ade871c2b4f77f33139b4dd225f113656de0375e32c"
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
