class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/43/44/7e646042c3c3fde7be4ef8debd6bc42f32f36766ab526af302abd341a9a1/tox-3.27.1.tar.gz"
  sha256 "b2a920e35a668cc06942ffd1cf3a4fb221a4d909ca72191fb6d84b0b18a7be04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b2a8b4f457069bc03dc19fee6b47cc15f8b33b00dc9d8e1169750aaa1bf7d88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca4535a1a24a1bf431cffaaea5da32f3b45642ad8e475cc9e599c9cca89eb8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c42cf73c11b29b6966adacce62e86007b27d0c5891e8e41daca6066b541b23a7"
    sha256 cellar: :any_skip_relocation, ventura:        "2182413a454307353f22f24c4d14800acc34f78345d5c8d5e6c04d5bf232bdb6"
    sha256 cellar: :any_skip_relocation, monterey:       "96c61f9bcda35bf326713a9c831ab5ae2d22795e529a3857850ae3c71c9d898a"
    sha256 cellar: :any_skip_relocation, big_sur:        "92d1cad9fb3891528d37787d35f4a437617d437aac3a9d041ae4ed3690a15563"
    sha256 cellar: :any_skip_relocation, catalina:       "fe5efcb86829c0b00917954d7b4824e899462f74d1551a8c4894422f9ccc2c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7a6a074222a543997412ce8f6ea38cf1d520be5370cbf83b6ba6fbd07ec664"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/5f/dda8451435f17ed8043eab5ffe04e47d703debe8fe845eb074f42260e50a/platformdirs-2.5.4.tar.gz"
    sha256 "1006647646d80f16130f052404c6b901e80ee4ed6bef6792e1f238a8969106f7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/2b/dc/be4da7a7fea4e8c3612a4f1901efc694b4f5f1c30179518ffef88c5f8dde/virtualenv-20.16.7.tar.gz"
    sha256 "8691e3ff9387f743e00f6bb20f70121f5e4f596cae754531f2b3b3a1b1ac696e"
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
    ENV["LC_ALL"] = "en_US.UTF-8"
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")
    (testpath/"tox.ini").write <<~EOS
      [tox]
      envlist=py#{pyver}
      skipsdist=True

      [testenv]
      deps=pytest
      commands=pytest
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    assert_predicate testpath/".tox/py#{pyver}", :exist?
  end
end
