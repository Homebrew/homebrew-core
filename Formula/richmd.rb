class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/ae/f6/6ffb46f6cf0bb584e44279accd3321cb838b78b324031feb8fd9adf63ed2/rich-9.13.0.tar.gz"
  sha256 "d59e94a0e3e686f0d268fe5c7060baa1bd6744abca71b45351f5850a3aaa6764"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3cb05a5be962f914908e05d1e788ce639c0873de907a322c266b5387eb5088f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d297c65f21ca4d9f0f2b1f629a58f878eb1262aec6fb48202ca51a56536d99c6"
    sha256 cellar: :any_skip_relocation, catalina:      "7b39ce207934d9327bb4ea8f63898124be3253990adfe0245b36c1bc3a2975a3"
    sha256 cellar: :any_skip_relocation, mojave:        "2264250d39f74ff907b290a7386eb1262e4ac8af99fd236a214c5e529842644c"
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/19/d0/dec5604a275b19b0ebd2b9c43730ce39549c8cd8602043eaf40c541a7256/Pygments-2.8.0.tar.gz"
    sha256 "37a13ba168a02ac54cc5891a42b1caec333e59b66addb7fa633ea8a6d73445c0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/richmd foo.md").strip
  end
end
