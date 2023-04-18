class Rfcstrip < Formula
  desc "Strips headers and footers from RFCs and Internet-Drafts"
  homepage "https://github.com/mbj4668/rfcstrip"
  url "https://github.com/mbj4668/rfcstrip/archive/1.3.tar.gz"
  sha256 "bba42a64535f55bfd1eae0cf0b85f781dacf5f3ce323b16515f32cefff920c6b"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "30eac8c00df4eb27fa9c8b6bacf48ec6145e7bad5699832f56a38a4967501ecc"
  end

  resource "rfc1149" do
    url "https://www.ietf.org/rfc/rfc1149.txt"
    sha256 "a8660fa4f47bd5e3db1cd5d5baad983d8b6f3f1e8a1a04b8552f3c2ce8f33c18"
  end

  def install
    bin.install "rfcstrip"
  end

  test do
    resource("rfc1149").stage do
      stripped = shell_output("#{bin}/rfcstrip rfc1149.txt")
      assert !stripped.match(/\[Page \d+\]/) # RFC page numbering
      assert stripped.exclude?("\f") # form feed a.k.a. Control-L
    end
  end
end
