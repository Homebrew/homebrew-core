class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/85/60/8532f7ca17cea13de00e80e2fe1e6bd59a9379856706a027536b19daf0d3/yapf-0.31.0.tar.gz"
  sha256 "408fb9a2b254c302f49db83c59f9aa0b4b0fd0ec25be3a5c51181327922ff63d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b46a3dbefb7b1e3ff520b32d75744b90eca77200de3201a4be5a95bbd45de65e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b46a3dbefb7b1e3ff520b32d75744b90eca77200de3201a4be5a95bbd45de65e"
    sha256 cellar: :any_skip_relocation, monterey:       "a7a417d2b6e9a1c2cea6f5b470ad8e18687780c3c69b354d108baa85a6a50e87"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7a417d2b6e9a1c2cea6f5b470ad8e18687780c3c69b354d108baa85a6a50e87"
    sha256 cellar: :any_skip_relocation, catalina:       "a7a417d2b6e9a1c2cea6f5b470ad8e18687780c3c69b354d108baa85a6a50e87"
    sha256 cellar: :any_skip_relocation, mojave:         "a7a417d2b6e9a1c2cea6f5b470ad8e18687780c3c69b354d108baa85a6a50e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f401553a61944a8b9aad2059b04aac3c4e9cec64786736f5e8f39108782fb93"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
