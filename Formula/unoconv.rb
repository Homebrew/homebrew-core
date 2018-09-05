class Unoconv < Formula
  desc "Convert between any document format supported by OpenOffice"
  homepage "http://dag.wiee.rs/home-made/unoconv/"
  url "https://files.pythonhosted.org/packages/a2/b8/3131d20bfa2065e489edc7ca2dbfd66fd8d4fcbbde3476c76605a7e69269/unoconv-0.8.2.tar.gz"
  sha256 "c7091a409384c05b3509b18be6c8d7059d26f491dfa78660ecdfbde3e72b03be"
  head "https://github.com/dagwieers/unoconv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1af9e6f882f4b76d22f9f2dfe3c5426b45c81282b7957ba5daf6384cf521ed06" => :mojave
    sha256 "cb6ddbfbd729b82ab62289c996f8150044ea66ea6ec1fa54c64736eccb1fa964" => :high_sierra
    sha256 "cb6ddbfbd729b82ab62289c996f8150044ea66ea6ec1fa54c64736eccb1fa964" => :sierra
    sha256 "cb6ddbfbd729b82ab62289c996f8150044ea66ea6ec1fa54c64736eccb1fa964" => :el_capitan
  end

  depends_on "python@2"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<~EOS
    In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
  EOS
  end
end
