class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/5d/c5/bcd66bf5aae5587d3b4b69c74bee30889c46c9778e858942ce93a030e1f3/scikit_image-0.24.0.tar.gz"
  sha256 "5d16efe95da8edbeb363e0c4157b99becbd650a60b77f6e3af5768b66cf007ab"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d64e36caaa70664404ebc32cb82d1b3fc10674b2e7945f6e35e3448a22b5a57a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2cffd6770ac35f0dbb025cfa434e74a594a631af8fcf5dccb641548721f6729"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc7df5c3771d32949f69e2c81ea702f20cf31e2cce5e7e85e51e97eeb12a5835"
    sha256 cellar: :any_skip_relocation, sonoma:        "baed5a5e5a080aa79e65fc9dd46418432dc4dbbd57422b4912ef085a7d38c9b9"
    sha256 cellar: :any_skip_relocation, ventura:       "f5d998d670408670d758040ce73058572d1e49b7140f3679eb4900541e72eaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3416b17ddb6351488ca1e0205e463db98ded2f5500673bea7e685880ee6fd9b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/4f/34/a714fd354f5f7fe650477072d4da21446849b20c02045dcf7ac827495121/imageio-2.36.0.tar.gz"
    sha256 "1c8f294db862c256e9562354d65aa54725b8dafed7f10f02bb3ec20ec1678850"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/f2/14/6fe362c483166b3a44521ac5c92c98f096bd7fb05512e8730d0e23e152c9/tifffile-2024.9.20.tar.gz"
    sha256 "3fbf3be2f995a7051a8ae05a4be70c96fc0789f22ed6f1c4104c973cf68a640b"
  end

  def install
    virtualenv_install_with_resources
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/skimage/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~EOS
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    EOS
    shell_output("#{libexec}/bin/python test.py")
  end
end
