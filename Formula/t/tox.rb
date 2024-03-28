class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/8f/e2/98cbdadaa14d53b0f37ffcf4cbb1652ffb21f8b2f300e43f17167136af1c/tox-4.14.2.tar.gz"
  sha256 "0defb44f6dafd911b61788325741cc6b2e12ea71f987ac025ad4d649f1f1a104"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a176b023d7ea318a82a9aa15866a98608b6f285fe2065a53a342ed3dac7371c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a176b023d7ea318a82a9aa15866a98608b6f285fe2065a53a342ed3dac7371c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a176b023d7ea318a82a9aa15866a98608b6f285fe2065a53a342ed3dac7371c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ce5fa259719584397cb717bff95471c768bbc7dad137f58428e1f5db823efba"
    sha256 cellar: :any_skip_relocation, ventura:        "8ce5fa259719584397cb717bff95471c768bbc7dad137f58428e1f5db823efba"
    sha256 cellar: :any_skip_relocation, monterey:       "8ce5fa259719584397cb717bff95471c768bbc7dad137f58428e1f5db823efba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbda0b0d9f4630ea34fe2c20b75ec0729678ccb99da44bf54dbf072e0f641660"
  end

  depends_on "python@3.12"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
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
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/1b/c6/b39e42e1d721dcb35be6a7d35157795398193ec0b78a034c110bd0ab3e48/pyproject_api-1.6.1.tar.gz"
    sha256 "1817dc018adc0d1ff9ca1ed8c60e1623d5aaca40814b953af14a9cf9a5cae538"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/93/4f/a7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250/virtualenv-20.25.1.tar.gz"
    sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
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
