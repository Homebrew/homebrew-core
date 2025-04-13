class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.03/rakudo-2025.03.tar.gz"
  sha256 "f690417517119cf0db9dc2e67301e108a9c48049621aa81ed0d99818cd2c8258"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "ce5d821e2e05cb3a236068b0fb70c409c52530822063c7daa440d5f55c9a6562"
    sha256 arm64_sonoma:  "18a8249faecc81bf49a9928eb2677c14cafd668969085daf74511161c26c53a0"
    sha256 arm64_ventura: "ab04e2feecd15c74d0207b60982a748f068d3f7bdafef996c53480cd10f44175"
    sha256 sonoma:        "93eb80e9d5c93993c40129fe04b48171a03d8bce163d3faa6827cf9a9155b29f"
    sha256 ventura:       "3973a70b78e1586579dc72872aab8a6a77a5671adc3e7aa4f9d27e223ef3df18"
    sha256 arm64_linux:   "c39864f1839574a062c9d2259931cb85e5f6cd6304c53ef6d8ef5b380d76b078"
    sha256 x86_64_linux:  "8b8d18b1bf66e71cbec2a8523fa0090a51adf9b476ef84970c657fc6a68c59c9"
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
