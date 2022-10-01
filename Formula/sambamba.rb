class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "10f7160db5a1c50296b32e94f7d7570739aa7d90c93fe0981246fe89eab6dd98"
  license "GPL-2.0-or-later"

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
    resource("homebrew-testdata").unpack testpath
    system "#{bin}/sambamba", "view", "-S", "ex1_header.sam", "-f", "bam", "-o", "ex1_header.bam"
    system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.sorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.sorted.bam", :exist?
  end
end
