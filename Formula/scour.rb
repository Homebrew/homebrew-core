class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.36.tar.gz"
  sha256 "1b6820430c671c71406bf79afced676699d03bd3fcc65f01a651da5dcbcf3d3b"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ad78d7432ab304f132fc35713b6fb1c930adfd245a55693f932fc460ee00f4" => :high_sierra
    sha256 "6f38d0966f43d293688b66ea4fd518e0c03f8aa2f9aef66940f86b319aa3fbc5" => :sierra
    sha256 "26b5885d3e21030da63a640e044ef553d0ec8828a15cbeac9a19eaaab00be637" => :el_capitan
    sha256 "cf80be6ef39cbcdb2e4944799442f0d5fa2a76295fb54eae8677de6b72c8626d" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
