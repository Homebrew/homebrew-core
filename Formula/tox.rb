class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/6c/0e/b9789bd4eee8cc8adfb8127730a13dfcf2d5cc7c419da904cf6fbf459d37/tox-3.24.5.tar.gz"
  sha256 "67e0e32c90e278251fea45b696d0fef3879089ccbe979b0c556d35d5a70e2993"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a75832e03f0645ae8daabf004505b77e8550bb8a13457ba4f3f32e2737b65cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76ad045466f2f3fc8900ac2010ee144e18580fa59e97536c2f13d53f7d8dea24"
    sha256 cellar: :any_skip_relocation, monterey:       "46fc027a68ad251af2d0dcfdf3d913d9d259feb7d57acc61925dd80ad1cba430"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7f624308ad3dd4ab89a58c99ef015921a6040d5b0aa4b88817d57907108482"
    sha256 cellar: :any_skip_relocation, catalina:       "f2acdf4e0a50628da327640323cf0560bb992a922656f2f28ee5d16b4613ae8e"
    sha256 cellar: :any_skip_relocation, mojave:         "270713525556bda12a9d880fbac12bc83818b493df68c16e046707c033eca99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fda9d04d879d5c1293fbf2fcf8d31494536f143c948c45c3509e552c6b3427e"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
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
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/29/25/e9626115f1be59b3890ad480d174343fae96045ebac337eed4ede0b3dfd6/virtualenv-20.11.1.tar.gz"
    sha256 "17f26e9d0c4350d9df713d41077b2b3344cba59e104306e4105c8c75deeddcf7"
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
    pyver = Language::Python.major_minor_version(Formula["python@3.10"].opt_bin/"python3").to_s.delete(".")
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
