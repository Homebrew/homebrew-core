class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/b2/7b/6cb14ae53aa80e57e9ac07431624a83d8f5b09af1284b5a3850fb09b8d4e/tox-4.6.3.tar.gz"
  sha256 "9e2c5091a117d03b583c57c4c40aecd068099c17d40520e7b165e85c19334534"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c01bf53dafb81737288935cd34261e7a377bf0e944dcfb7d3d986262176656fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "019f405e23318a70b34c68c93be69e3bb15780ad073424d4a7737ff4c84b98a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc228cd53db4e6bd968f83d5afe10567da35f9b6d9feb8f3dcebb010ec267b2"
    sha256 cellar: :any_skip_relocation, ventura:        "4719593e1b3d90b0608458d229ccec8c53985e408dfa71b9bb1c7b516e4d150f"
    sha256 cellar: :any_skip_relocation, monterey:       "215dedcc9e57556141c0d6af82d7332758319677bf27c94f8696e7ff26398d5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7da5ca587b48043f7491cc06f41f600f30a443811fba34b14e4d463a2b021735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0cb378fe0937fb8647e8715c8651b39b9f59bc15d117cdd40e4cf7d035a686"
  end

  depends_on "python@3.11"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
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
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/05/31/793923615e85deef0c25abf5d044b3f99f1348b620122ab184b7d3f70f21/platformdirs-3.6.0.tar.gz"
    sha256 "57e28820ca8094678b807ff529196506d7a21e17156cb1cddb3e74cebce54640"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/6f/26/82a2773463e1b739b62e432cff62d39daf21b3172e5ace6213b7f2bbfad7/pyproject_api-1.5.2.tar.gz"
    sha256 "999f58fa3c92b23ebd31a6bad5d1f87d456744d75e05391be7f5c729015d3d91"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/21/6b/0910aebe4d5c2a27d5a79ab8fae06d22f7e01dff46baf29ced8d080134c3/virtualenv-20.23.1.tar.gz"
    sha256 "8ff19a38c1021c742148edc4f81cb43d7f8c6816d2ede2ab72af5b84c749ade1"
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
