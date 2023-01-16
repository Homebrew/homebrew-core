class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/5a/ed/8ac59f9062ccea7367cb0996de7f6b2adad4af6c4428527f14b61ef3cbb4/tox-4.3.2.tar.gz"
  sha256 "95bc7bf7d959563a29775a18a6fc5794724124d8212fa1ec3b81e0ff579fb710"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "027a5120be527db42c1ab4e2affe3d71ac14bbebe6941c0ac912d3512a3aab5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615f227e6e9b139ae3dc74361a572e6765cb6f0127bdbc420f0720304d058e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65c6b5c3a06ebf58e3b14e6cf72b7ac74716dd3ea0db873ef78c1ff5b317c23c"
    sha256 cellar: :any_skip_relocation, ventura:        "d6f6030dcd76b32cb8ec65658de73b281604f61ec95cdcbc96218ef799e89583"
    sha256 cellar: :any_skip_relocation, monterey:       "bafc8ef0478a5a21b2787e121ad7b74cbf96c01a6b141497e34ede8163529f8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0e8ab769a3877451cfafd1cbd1867dea7654eaebd74ec764ed576206a76cd15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30d187c4260855aea29249aa127f12e197e1503c9a54e0fac079ebcd85740332"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/3d/cf/8bab81474cb9ec7879ba28aef71c8351db92cd03587d9eac8e908b2c1c23/cachetools-5.2.1.tar.gz"
    sha256 "5991bc0e08a1319bb618d3195ca5b6bc76646a49c21d55962977197b301cc1fe"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/08/87/d1d350a5aa74baf598030fcdadc78b42a83014a3c0583354f4b5ecf1cf14/pyproject_api-1.4.0.tar.gz"
    sha256 "ac85c1f82e0291dbae5a7739dbb9a990e11ee4034c9b5599ea714f07a24ecd71"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7b/19/65f13cff26c8cc11fdfcb0499cd8f13388dd7b35a79a376755f152b42d86/virtualenv-20.17.1.tar.gz"
    sha256 "f8b927684efc6f1cc206c9db297a570ab9ad0e51c16fa9e45487d36d1905c058"
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
