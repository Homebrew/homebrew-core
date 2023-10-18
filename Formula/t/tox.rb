class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/c9/48/7744b1a3ebf2ae5e3bf6a23e8f9775476ae770061fa912db1c966a720fbf/tox-4.11.3.tar.gz"
  sha256 "5039f68276461fae6a9452a3b2c7295798f00a0e92edcd9a3b78ba1a73577951"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c29bbe3bb11284b6e9abff03c6edc6a6f9205358323f4a806a7023e7234519e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a968c4368429f468a49abcdf5cfbfc2e5f6e35494fcbb83e0d03506373895aa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000489ca9ac0ed9d47d93d2539042bd1f8b0b1d8f951be95af2a441770960a0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84bf272cb1aab37dd222bfc8428aa063b30c16c84e94ff6d27892dc9928dad3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5724ba8de672cf5836a9d0d76bdf348355b1ea986f7b9b2ec94151d3027596f"
    sha256 cellar: :any_skip_relocation, ventura:        "d6891295d2dda0a440759197f15af3ebd3bbf48c3b9eb891981422accfcaf263"
    sha256 cellar: :any_skip_relocation, monterey:       "5c62b8f473b68d13701cc10b8476b0a8f33325d030527b4b41a40724e14a17b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b26f96f2f1154b30b733d94ad76074135b30784cb4778de7f27adeb08229475c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c22a8548df1ed782243f64663e8373c1178ca27c49a17389cc98aee7d140c9"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

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

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/1b/c6/b39e42e1d721dcb35be6a7d35157795398193ec0b78a034c110bd0ab3e48/pyproject_api-1.6.1.tar.gz"
    sha256 "1817dc018adc0d1ff9ca1ed8c60e1623d5aaca40814b953af14a9cf9a5cae538"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d3/50/fa955bbda25c0f01297843be105f9d022f461423e69a6ab487ed6cabf75d/virtualenv-20.24.5.tar.gz"
    sha256 "e8361967f6da6fbdf1426483bfe9fca8287c242ac0bc30429905721cefbff752"
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
