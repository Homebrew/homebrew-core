class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/c9/48/7744b1a3ebf2ae5e3bf6a23e8f9775476ae770061fa912db1c966a720fbf/tox-4.11.3.tar.gz"
  sha256 "5039f68276461fae6a9452a3b2c7295798f00a0e92edcd9a3b78ba1a73577951"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9811cbfdd9ae556a369add526d52de1dbbb4fc90c5b6ca4afb1597e4f206856"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c7506943730e201432c0b694205e03d9c66fdf25b57e3822ac27f6b7818d4c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e08854cc944cebe92744edf6be8fcfa1c1237c647919a1ad8ae8497d51e8cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "42d19d3506ef0630f76db71f3ff651b96e6f9d85ba0feae987d815657b30ccc9"
    sha256 cellar: :any_skip_relocation, ventura:        "007fdaa2560c328a4d0913f5ea265e01bcd00a81fc90ea4f940d39021d4b4f10"
    sha256 cellar: :any_skip_relocation, monterey:       "9fda3fcd721cf9d94a65462d3914db63fdfcf473ca368d4db353c68b4030200c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c60c20eb9a389a506d5faf36f81bc67ecacc9623f2c3ce27f3bb491e2b23b1"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/1b/c6/b39e42e1d721dcb35be6a7d35157795398193ec0b78a034c110bd0ab3e48/pyproject_api-1.6.1.tar.gz"
    sha256 "1817dc018adc0d1ff9ca1ed8c60e1623d5aaca40814b953af14a9cf9a5cae538"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
    pyver = Language::Python.major_minor_version(Formula["python@3.12"].opt_bin/"python3.12").to_s.delete(".")

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
