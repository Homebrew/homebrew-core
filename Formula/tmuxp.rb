class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/fb/1c/ad297105e1b3a5faa57a215ae1d106203ce1fd8a9166484d01da10c670c2/tmuxp-1.16.0.tar.gz"
  sha256 "8fbbb615c79681bfbd323a3d5d8b27b840540cf0160821999eb197c82666f59d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282efd12b665b8ed8be9725f39f8bbc225940f065a41876392f966cdd1b5c865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ab689139730251b5a5759496d76086f70c02ae16b6299749a505e8043b43762"
    sha256 cellar: :any_skip_relocation, monterey:       "c61899330368dec20662e57120754db5b87c3187a859adb730ae53bd8cfef04a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82f5f089762a1c107f846721176b898c5fb4348a396233e3e40abf016978fd29"
    sha256 cellar: :any_skip_relocation, catalina:       "75972b305cc8de76f2183bea21f1a0f30d855fa47248afd2a3e02bc56babafb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3055c200eb2fdd6ba43db519292853c459843403cb531d00068ada05aae5d12a"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/ff/57093d287ae579f4fbf357a072b92551663cca95588c4835a86fd0130ff3/libtmux-0.15.7.tar.gz"
    sha256 "dee2a138e0eab14256472d140ac816c923c303406b894e27c068cc39f5f8bfb4"
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
