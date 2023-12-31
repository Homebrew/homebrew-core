class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2023.12/rakudo-2023.12.tar.gz"
  sha256 "01a4131fb79a63a563b71a40f534d4f3db15cc71c72f8ae19f965b786e98baea"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9ec4fb8508cd61f176694b25b29215c8069552f872884bb9cdf620ee9d090aea"
    sha256 arm64_ventura:  "10fc15daf4efae2eff6d5836bacdcdf1f1be9edddd737dac1fb4243dd63f8d24"
    sha256 arm64_monterey: "88bb3002723ad69d7c0c4ed689d6b51f5907844609cced943ca6a689e61eda42"
    sha256 sonoma:         "3b2832ef57a1afae30f2eea35a4dde4538f93683f197bc89d4c50d11580b14ee"
    sha256 ventura:        "d9b0be7c2740e4bf15f02bee245bc062c5828748c9f08a932bc42616a147469a"
    sha256 monterey:       "bba7dd3f393297b95e15c94d9b682972525f179e7f330ac4f325dc14ff9e49c7"
    sha256 x86_64_linux:   "aea42e1749ed68e5a0e77fc132fac5b77cfc09043391ab31faa4ad74991c3495"
  end

  depends_on "libtommath"
  depends_on "libuv"
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
