class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/c4/a2/bd305bdb7b1c76a27f5e99d101059d9e1a65fa5dba1bd4a97f725f27a473/tox-4.65.3.tar.gz"
  sha256 "1749d05a0fd04db8fed344a61ca047122d98b3347363d940d9cf6098b05e61cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21fad753dbfaf87d9434fb9cf455e2b74dda4c2537e8e6fe15a2e0ea266e96ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21fad753dbfaf87d9434fb9cf455e2b74dda4c2537e8e6fe15a2e0ea266e96ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21fad753dbfaf87d9434fb9cf455e2b74dda4c2537e8e6fe15a2e0ea266e96ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d92ddc9ad7b717244edfa64627f3211ec9931f4649f4aacbdb3e770a83073ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d92ddc9ad7b717244edfa64627f3211ec9931f4649f4aacbdb3e770a83073ba1"
  end

  depends_on "python@3.15"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/31/44/71476a5812da1ddf2c9a3efd31ae76d01480a1cf03ed13ac28aa8f2402e4/cachetools-7.2.1.tar.gz"
    sha256 "b1a7537025c06abf96fcc1443e496af9a3fb95e774e70e1f0af226f73f7f2dcc"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4c/58/6fd434bec86eff7c38a3168454cb132b762b2bea9b3ac094101a2f7bc32a/filelock-4.1.0.tar.gz"
    sha256 "ad7f724afef953e731b1cc39bcd3a09166d72ed7fcdf29e6e88b1c3235c6715d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/3c/e1/148e4bbb469b26b6648dac4ee292aed80c1205c06ecd2e32987c7ed3e6f5/pyproject_api-1.11.5.tar.gz"
    sha256 "79294e79953a30fd3eac04bdf8b57241d33e2c8b7230b94c1b76e4d765fe09ad"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/92/f3/589727d02bc832750cfa00ced4315d127535a22a6d7cfcb369b2fe219a2e/virtualenv-21.14.6.tar.gz"
    sha256 "c6b74616e64bffa9532cfa9dfd54ffbab0dc9b999df2bb8ec0d75e559b983661"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

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
