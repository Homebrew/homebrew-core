class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/a5/b7/19c01717747076f63c54d871ada081cd711a7c9a7572f2225675c3858b94/tox-4.27.0.tar.gz"
  sha256 "b97d5ecc0c0d5755bcc5348387fef793e1bfa68eb33746412f4c60881d7f5f57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c582c303c7450c33fc559ac647544abb3ccdebacd96d64facc4cdb9bbdf2b406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c582c303c7450c33fc559ac647544abb3ccdebacd96d64facc4cdb9bbdf2b406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c582c303c7450c33fc559ac647544abb3ccdebacd96d64facc4cdb9bbdf2b406"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef954906a349211b69b375579552b68602b6478aa7d32aafa91a713a531fc75"
    sha256 cellar: :any_skip_relocation, ventura:       "bef954906a349211b69b375579552b68602b6478aa7d32aafa91a713a531fc75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e9ad72692b7de20e73ccdfa2e68adcea0cce54ef8a199b237d1089536a28988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9ad72692b7de20e73ccdfa2e68adcea0cce54ef8a199b237d1089536a28988"
  end

  depends_on "python@3.13"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/8a/89/817ad5d0411f136c484d535952aef74af9b25e0d99e90cdffbe121e6d628/cachetools-6.1.0.tar.gz"
    sha256 "b4c4f404392848db3ce7aac34950d17be4d864da4b8b66911008e430bc544587"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/19/fd/437901c891f58a7b9096511750247535e891d2d5a5a6eefbc9386a2b41d5/pyproject_api-1.9.1.tar.gz"
    sha256 "43c9918f49daab37e302038fc1aed54a8c7a91a9fa935d00b9a485f37e0f5335"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/56/2c/444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94/virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(Formula["python@3.13"].opt_bin/"python3.13").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end
