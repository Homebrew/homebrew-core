class Sambamba < Formula
  desc "Tools for working with SAM/BAM data"
  homepage "https://lomereiter.github.io/sambamba/"
  url "https://github.com/biod/sambamba/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "10f7160db5a1c50296b32e94f7d7570739aa7d90c93fe0981246fe89eab6dd98"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8fa5db4c381cdb2dd7f62dec9e2eba2acdeceaea3d62809fde83d30cca6624e4"
    sha256 cellar: :any,                 arm64_big_sur:  "8a2c3933eee3a6b8a8bc79828edc8f3b102a0172496081b1de124b763b698c5a"
    sha256 cellar: :any,                 monterey:       "9b9676ff4648e7fccfb38b9759b6f860ebde95ab82a5db5817b1c71323ce0c48"
    sha256 cellar: :any,                 big_sur:        "2bb46c59c474b37504d4c20bd0cb5d218c0ac8260bcd31717a7b8c1cf87de8eb"
    sha256 cellar: :any,                 catalina:       "57897d985402185cfe2a311893b4e98ebe05a450346a39e7d11716a5924cb4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ada234fb653592954123072c1ae9f4a956e195a4e57212d08bcfe710eb96015"
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
    resource("homebrew-testdata").unpack testpath
    system "#{bin}/sambamba", "view", "-S", "ex1_header.sam", "-f", "bam", "-o", "ex1_header.bam"
    system "#{bin}/sambamba", "sort", "-t2", "-n", "ex1_header.bam", "-o", "ex1_header.sorted.bam", "-m", "200K"
    assert_predicate testpath/"ex1_header.sorted.bam", :exist?
  end
end
