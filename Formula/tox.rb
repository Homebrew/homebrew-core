class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/7c/6a/2a746db0157c39bf622cea42f6e67a6c1887b5f50b2de48dec226a4c72f1/tox-3.25.0.tar.gz"
  sha256 "37888f3092aa4e9f835fc8cc6dadbaaa0782651c41ef359e3a5743fcb0308160"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f13cd2a8975e0139d983ae52db85af264f706eb9b88284fe47fdc727089a076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "746d286dab5e0a71a4bb9d07547768bc253a5a8e8b7ad763bd46833c4e5d397d"
    sha256 cellar: :any_skip_relocation, monterey:       "6397963b0854e966b09e769631de7bdf00c9efd8ce45291ed556504087de8118"
    sha256 cellar: :any_skip_relocation, big_sur:        "aab3460f96c584347ed4fb39b7caeca3190b6db60c3e8423773e47a76b84e7d5"
    sha256 cellar: :any_skip_relocation, catalina:       "30c882b8d3a1e75ca5e0597093971c102c1fcfcd73cd7250f9c9ae79e8fcdb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1961a5d5edcf3143d25fea671634d07fd85d7195caf57f5107546b70f6d6943e"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
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
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/5f/6c/d44c403a54ceb4ec5179d1a963c69887d30dc5b300529ce67c05b4f16212/virtualenv-20.14.1.tar.gz"
    sha256 "ef589a79795589aada0c1c5b319486797c03b67ac3984c48c669c0e4f50df3a5"
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
