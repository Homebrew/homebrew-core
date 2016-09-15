class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/cd/3e/b914c3264766621992b0a381ccd3e7342d64640dc560f6aa411cc9594265/scour-0.35.tar.gz"
  sha256 "7b33a0fc7ed578e7d1fcf4f68eb4c38cd080c243ea57537840062d37cd0d3c8e"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6df26a6cada65c8e2c47f5ee4bfdf4ce2d75f2efdfeeb7904ed96f7392abcbbd" => :el_capitan
    sha256 "dc0f121ffd8c4b925231f1f0d82eed71ab4d99bb25030d37732995e17fe411ae" => :yosemite
    sha256 "4fc3ba5d18eef21375d17e9eac9fa2b57ff40abeba0ef31127fb3b39236d42e5" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert File.exist? "scrubbed.svg"
  end
end
