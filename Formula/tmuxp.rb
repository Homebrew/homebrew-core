class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/85/58/9864d7725df3db1216deffd9c6b91689218d9b045fbca5103b2ea8ba1cee/tmuxp-1.13.0.tar.gz"
  sha256 "9846df3ad247db9af0eaed881fc4d4de6a40137ea707e309e07df13ac4524b3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5533bed99c46ddeac74d27cdd290d7f486f2196cc87c16dcb8d5fe189ad9ffc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef88b317687e19bbae7e903c9061f488cdebe4cce9b1229ee0c3d2c3031fcaa5"
    sha256 cellar: :any_skip_relocation, monterey:       "1a555ef0f3f7a44d35feb64345bb8eccb6b54ad97ae632fe62712b050ace4b4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d25d15d7619ad8f54e960eb1fc9807180ddcab6d28a2dc469dcc94335c35073"
    sha256 cellar: :any_skip_relocation, catalina:       "4bac6aa7a6cbfaf41f0700850adcf224afac01e1eb665d81a82d0c21a3eb795d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7210f3fee5435245f61af5463ffe60022bbba89c3f855d8d6b7069f844fe7d"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/b2/8d/6a00c77d28ae7122f3d9f1b1cc127f07e24a82f224308bf4ea5fcd20baee/libtmux-0.14.0.tar.gz"
    sha256 "4def28144c9b4317560f771b8daca866542c0a4c147db8f33541546b14950a6c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
