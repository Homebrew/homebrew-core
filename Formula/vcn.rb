class Vcn < Formula
  desc "VChain Code Notary Command-Line Interface"
  homepage "https://www.codenotary.io"
  url "https://github.com/vchain-us/vcn/archive/0.4.1.tar.gz"
  sha256 "4a811b0832c5d7ea086bdfd13ca0b30d966d4195aac10eae5b17c4b98d7f3116"

  head do
    url "https://github.com/vchain-us/vcn.git"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath
    system "make", "install"
    bin.install "./vcn" => "vcn"
  end

  test do
    system "#{bin}/vcn", "--help"
  end
end
