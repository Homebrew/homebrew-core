class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.08/rakudo-2025.08.tar.gz"
  sha256 "caaa43756ad38763f444210d2b28483e6ea00930da8951b3d69f2bd9b1d6a7f8"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d5d0d3bfd754cea3a56a4c017428a505afef9ea963450af60efcbbb0da28a630"
    sha256 arm64_sequoia: "41c902a4da74cb0f7a92e7ee437302277dd1ca5bb4687b7abca1899d90b33021"
    sha256 arm64_sonoma:  "d693f10159eaef42d0fb7d02210a80e41425e6ae805058d71489a596bdc7d7e2"
    sha256 arm64_ventura: "7db4c3002973061f9fafb7ee5dfd1b52346fe6804ddf0e564bb428c6ecffac34"
    sha256 sonoma:        "a7d4c423373d43bd62af13b42cb348a1862a3d73de938d35193a6a52cef456ae"
    sha256 ventura:       "fbc089fb0685334d1058478fe54380513e0b735cfcc2195f843f6487f1bb2bcd"
    sha256 arm64_linux:   "af2f2e1e65a513af5f00cfb5998f640741fa525498cac58946046882865057c6"
    sha256 x86_64_linux:  "a052c7583cd90aaff43f36a1e2855c065a792b90046a95b1674c0ac6136b913f"
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
