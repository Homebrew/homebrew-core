class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/47/0c/c99dcd47a06cc29c95315a6857de932dfc42edd8bcb53825545279eb4130/tox-4.4.12.tar.gz"
  sha256 "740f5209d0dec19451b951ee5b1cce4a207acdc7357af84dbc8ec35bcf2c454e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f07ee014c7e2d9bb2fecf4deb09b85a5f5c0e917df2e095513d1f83486f9377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9990af821a1aa1af2f1bc79484f3ffbeb807156cb2aac0313804d638f36420b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbb5e9ec672f95142910ecc8554db2812b1d6528bb3e37f8f5dfcaea719e5f6"
    sha256 cellar: :any_skip_relocation, ventura:        "8f827b0228add24f7c9ecded112f7118065f64aa028cdb2099b5e920174541df"
    sha256 cellar: :any_skip_relocation, monterey:       "190693ce08b99457a0c59818d624eaa5ebf3aeeb6c533f13ea1276e90fd38498"
    sha256 cellar: :any_skip_relocation, big_sur:        "48809746c843553dd4990e1284a70045984668398cef6dd64087fde4cf3d3ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622ae2db365bc203f79e6f98e17ac726198df9e919cb03ca7f53788b29f54325"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
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
    url "https://files.pythonhosted.org/packages/e6/3d/c80975c1028f54e4f0fe6f727d9271362b749321144ea833216b18bfda93/filelock-3.11.0.tar.gz"
    sha256 "3618c0da67adcc0506b015fd11ef7faf1b493f0b40d87728e19986b536890c37"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/23/6f/d02d1cab4a30998806687036e03ffecbf66e35df6bfab5a29f22ec61a075/pyproject_api-1.5.1.tar.gz"
    sha256 "435f46547a9ff22cf4208ee274fca3e2869aeb062a4834adfc99a4dd64af3cf9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/87/14/ca9890d58cd33d9122eb87ffec2f3c6be0714785f992a0fd3b56a3b6c993/virtualenv-20.21.0.tar.gz"
    sha256 "f50e3e60f990a0757c9b68333c9fdaa72d7188caa417f96af9e52407831a3b68"
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
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_predicate testpath/"src/.tox/py#{pyver}", :exist?
  end
end
