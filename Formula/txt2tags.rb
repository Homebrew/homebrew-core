class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/a3/91/3522a1fbefcc02d3d496854aea81b2b01a6e388bdb27ca0be39a91a43711/txt2tags-3.8.tar.gz"
  sha256 "379869e866ed85225181ac65583827781a166c907de8bb40a9f3daf7b16c3483"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c733dd69bfebdbd7eaebcc27c4d80e2ed080cbcef5a71d22aa1965f6e4164bdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c733dd69bfebdbd7eaebcc27c4d80e2ed080cbcef5a71d22aa1965f6e4164bdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c733dd69bfebdbd7eaebcc27c4d80e2ed080cbcef5a71d22aa1965f6e4164bdb"
    sha256 cellar: :any_skip_relocation, ventura:        "337725d77060c6e7f0ddd638ff0d904b98aca4b78748327b0494b7ab02584c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "337725d77060c6e7f0ddd638ff0d904b98aca4b78748327b0494b7ab02584c8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "337725d77060c6e7f0ddd638ff0d904b98aca4b78748327b0494b7ab02584c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe92bcad887b8e2d4f32d1b2afe040e2577852d6d1eb4ec327ef62f05c4a826"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
