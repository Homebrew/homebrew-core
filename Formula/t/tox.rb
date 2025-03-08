class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/51/93/30e4d662748d8451acde46feca03886b85bd74a453691d56abc44ef4bd37/tox-4.24.2.tar.gz"
  sha256 "d5948b350f76fae436d6545a5e87c2b676ab7a0d7d88c1308651245eadbe8aea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7427d21cc3fa5aa8b8a7c83b1df901f1d674e00c60bc42c010283d5d16ccdd2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7427d21cc3fa5aa8b8a7c83b1df901f1d674e00c60bc42c010283d5d16ccdd2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7427d21cc3fa5aa8b8a7c83b1df901f1d674e00c60bc42c010283d5d16ccdd2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "063756b11bd0ad386dbf87837affb6e6c4f5ea62bc69a0de22eb5992ccf83e12"
    sha256 cellar: :any_skip_relocation, ventura:       "063756b11bd0ad386dbf87837affb6e6c4f5ea62bc69a0de22eb5992ccf83e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e3108799b0462889e0ab49d054541308426fef2d9be8f5e1c274465a4d3f486"
  end

  depends_on "python@3.13"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/6c/81/3747dad6b14fa2cf53fcf10548cf5aea6913e96fab41a3c198676f8948a5/cachetools-5.5.2.tar.gz"
    sha256 "1a661caa9175d26759571b2e19580f9d6393969e5dfca11fdb1f947a23e640d4"
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
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/7e/66/fdc17e94486836eda4ba7113c0db9ac7e2f4eea1b968ee09de2fe75e391b/pyproject_api-1.9.0.tar.gz"
    sha256 "7e8a9854b2dfb49454fae421cb86af43efbb2b2454e5646ffb7623540321ae6e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c7/9c/57d19fa093bcf5ac61a48087dd44d00655f85421d1aa9722f8befbf3f40a/virtualenv-20.29.3.tar.gz"
    sha256 "95e39403fcf3940ac45bc717597dba16110b74506131845d9b687d5e73d947ac"
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
