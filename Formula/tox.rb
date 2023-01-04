class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/31/76/7f922f131b617183969c02a3b661232d7d1ae2b1e70ed22baea31d68884f/tox-4.2.1.tar.gz"
  sha256 "cd4bea2b2cfa2a3f60c3dfae843840297559e8a341206638a96324a2ff8b8a60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cac90a3dd67fbbd87ea48cb8a0b6311f722527a43987609c4647b804643725b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "543cf406ed21f6075a96525f90d2c4505a943954ededb828e339d0a0f273f42a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f8ba201ee2c302895c162035fae325daf0535bb084eb6720e454cd3d4f6ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "1a4545a95d2b020ec2ee3ee290a60ffb023bb16e8396fc2265383f214ceb60cd"
    sha256 cellar: :any_skip_relocation, monterey:       "e192122aa607dd44c8974c8d00015bde6beaa2eafff92ffb51fed108ca24b284"
    sha256 cellar: :any_skip_relocation, big_sur:        "43bfd88c203d02e1804bf0e3e3472deb2678bddea4a73773f62726131bef762d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc34ea55d2c76ca73cd7b4d92ee751c927e7add3e85e9107e95c220c4a7a74d"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
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
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
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
    url "https://files.pythonhosted.org/packages/5a/3a/02dfa3cfcd4bfc36d9118f9f9a76594928f51bbcbcea7ee544026ac8465d/pyproject_api-1.3.0.tar.gz"
    sha256 "6da9b5fcad6f6bdcf88ee0dbc6cc41783e377ceb6767b5004881ecb50ae6d6e7"
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
