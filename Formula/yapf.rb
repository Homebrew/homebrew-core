class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/85/60/8532f7ca17cea13de00e80e2fe1e6bd59a9379856706a027536b19daf0d3/yapf-0.31.0.tar.gz"
  sha256 "408fb9a2b254c302f49db83c59f9aa0b4b0fd0ec25be3a5c51181327922ff63d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47e90fbe675d07d273b421a8313d1321104ae9edb8287a16b4cf14faa4ca5cf7"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2961b0fc70a7c6606769d55ca60329902e9cd2d32b78d8551740870805cb232"
    sha256 cellar: :any_skip_relocation, catalina:      "758d20404a5f18909269e0264cc8138e8d8a91af9200ace5c1bb3ded925dfedb"
    sha256 cellar: :any_skip_relocation, mojave:        "0f417b3d8e112b8de9224583fb8fd0dd5fad955e167b2baae9c6d07a00733477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb5ae98b024f3537b3273a1985b052796966890d9119bbe6e26db776750646c0"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
