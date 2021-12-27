class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/c2/cd/d0d1e95b8d78b8097d90ca97af92f4af7fb2e867262a2b6e37d6f48e612a/yapf-0.32.0.tar.gz"
  sha256 "a3f5085d37ef7e3e004c4ba9f9b3e40c54ff1901cd111f05145ae313a7c67d1b"
  license "Apache-2.0"

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
