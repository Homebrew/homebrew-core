class Treecc < Formula
  desc "Aspect-oriented approach to writing compilers"
  homepage "https://gnu.org/software/dotgnu/treecc/treecc.html"
  url "https://download.savannah.gnu.org/releases/dotgnu-pnet/treecc-0.3.10.tar.gz"
  sha256 "5e9d20a6938e0c6fedfed0cabc7e9e984024e4881b748d076e8c75f1aeb6efe7"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/dotgnu-pnet/"
    regex(/href=.*?treecc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "239d0728cb07d6376c1da25192595b472842acd775b7d95570786fac003ca10f" => :big_sur
    sha256 "b29736a869955071e87b8be7b9d8f7a36e1c2d4f52796e49bbef8d5c002147b6" => :arm64_big_sur
    sha256 "3a46948ef72e0801cab4767e1f0075d01ab8b7a8eb4b07a9a7e81d021c43e2fc" => :catalina
    sha256 "4e9b82d074d10eae24c0c7e95879435ec8896072669d826614f34213843bfe5e" => :mojave
    sha256 "c05c019775b00f92fe2ea47a02c999356105789b9aa5536c4356090ccbb9ba99" => :high_sierra
    sha256 "0b3e61d5a910222d170fcee80d094be0dcd2707b7bebc6d40667a8f25b4b2e5c" => :sierra
    sha256 "e74d23594113e594ad8021fe55b0f0f863fcd4b01140c3fd8b1a5f2bb6c8ad74" => :el_capitan
    sha256 "595dada9ecb2cef6d3e225e99a98997968d15f8009038511c464b6499cbcd872" => :yosemite
    sha256 "9f9a9e6a66c9e0a60888ad2af502070683637b5cd19dec6e080211a45c3313e6" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "treecc"
  end

  test do
    system "#{bin}/treecc", "-v"
  end
end
