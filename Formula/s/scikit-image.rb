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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9e75ed9b259ac0379c32790f8a838aed9de2537736699f7c800f6639eccc5c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aeefa1537ddfbf9c2a8dd2bc77853c333e8f99a71cce6d35daeb10e95107f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77a258de0568a6bc6405b67707dba97b25dffe1338dbe37b39fc63b5c4c78d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096478908be082b78050b357a271c440015be85e21961fb827345780b34baa21"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e28919721e67e5ec677e22851352097ec70c56e811aa1836d3d6a82bf36f477"
    sha256 cellar: :any_skip_relocation, ventura:        "e1710b3af9a709a4a42144623a274766bda6736c69b5d17ab6b918c4557ca87a"
    sha256 cellar: :any_skip_relocation, monterey:       "97cb05e332e4b5d31c1d09a44291cb2cce4938ec44a7834a9fb197201b89ec15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a22e7dd8bb37445bc526d3f719e48738d53a46deddd6e088ada56e0663e5ef4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/2c/f9/aa9f3a4eae46f4727902516dc7b365356c1e4e883156532b74d135a69887/imageio-2.34.1.tar.gz"
    sha256 "f13eb76e4922f936ac4a7fec77ce8a783e63b93543d4ea3e40793a6cabd9ac7d"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/8d/e5/c58f2dc22f6372516d1154ce1874c74cecf7c52892ad5f09bf3764b6b1b2/tifffile-2024.6.18.tar.gz"
    sha256 "57e0d2a034bcb6287ea3155d8716508dfac86443a257f6502b57ee7f8a33b3b6"
  end

  def install
    virtualenv_install_with_resources
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm(Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/skimage/**/*.pyc"])
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
