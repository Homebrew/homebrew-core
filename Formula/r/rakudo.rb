class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2024.09/rakudo-2024.09.tar.gz"
  sha256 "dbd4da67aef46c645f0cf6e44c296dc8c6c8cc0354cb18ad39c23adb94458528"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "f5a69068016e85ac700339bd93486fd137b4fb88a373ce29dbf2570d831ba0b9"
    sha256 arm64_sonoma:  "08bf7b0ffbf03638d4a9dcbc9f2ed9fe2386de14d47d2c8ad6b90a869e74b753"
    sha256 arm64_ventura: "851c8f459c3f5450c2d046a1389634a996d7e4678d33a11145f7e9e79e6d0103"
    sha256 sonoma:        "0a6861b8e4ec2851b451d23f918b0d31ce260d12e19539433fd63969a196db73"
    sha256 ventura:       "518c0e938d6145847428581df76a170e5085afa5d2649398e5c8a10570e7041d"
    sha256 x86_64_linux:  "ac8941c92498f93f8e165cb66b6e5066d3f77c295a7554a24e6048014454f224"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"
  depends_on "nqp"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"
    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end
