class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6992c5c29f7917e404dd2b32fff4e75e3655c27129053e5fa01cfabe1f4d071f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65fec6529bf575d9b2b9862176e7473bede61ae4b9f62d1a774c92b178ce191c"
    sha256 cellar: :any,                 arm64_monterey: "95c29568fd32c390b9f7fb3b987571de33bec7b7c69f10ff361b2e2db3c16ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "1184fa77484b25973406fcb32f502c2e9ee59aacb696264e4f5cc6288bcb0047"
    sha256 cellar: :any,                 ventura:        "c3a31963af0c4fb3ecbac0ba82b713f9846015f3102cbec71ef36d656467746f"
    sha256 cellar: :any,                 monterey:       "5a87b0561b1c39d09c5fcdb194c72761da5caed1f7179e4951b09ec36446200f"
    sha256 cellar: :any,                 big_sur:        "75c2ecf2e3d05a749cbf6b9cbab7ecb393eeea5b4d89cb678b4502beab45c1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "babf0d1ef2aede94f2e48c3def6d1fa50f8450f2d2002f23394858169a4d3014"
  end

  depends_on "ldc" => :build
  depends_on "lz4"
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/biod/sambamba/f898046c5b9c1a97156ef041e61ac3c42955a716/test/ex1_header.sam"
    sha256 "63c39c2e31718237a980c178b404b6b9a634a66e83230b8584e30454a315cc5e"
  end

  def install
    # Disable unsupported 80-bit custom floats on ARM
    inreplace "BioD/bio/std/hts/thirdparty/msgpack.d", "version = NonX86;", ""
    system "make", "release"
    bin.install "bin/sambamba-#{version}" => "sambamba"
  end

  test do
    resource("homebrew-testdata").stage testpath
    system "#{bin}/sambamba", "view", "-S", "ex1_header.sam", "-f", "bam", "-o", "ex1_header.bam"
    system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.sorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.sorted.bam", :exist?
  end
end
