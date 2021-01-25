class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/scour-project/scour.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a38cf4f698ba7237dc73aa677713794e8883d7c8618960ef70b951240a0c8dea" => :big_sur
    sha256 "4530f553f087c0f15ce5119f60efd33d39ef42105678874bc2316ab4f5910fe4" => :arm64_big_sur
    sha256 "b2877da612f4182fe695b2bb925d9af530aae2927c0a02cb2a4a37cde04df5d1" => :catalina
    sha256 "d5c972cf38a4e907d47f6cd2c1b0c5a89d87483e8a7c78bd45465fcb9b5bfc23" => :mojave
  end

  depends_on "python@3.9"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
