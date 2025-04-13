class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ce7210b6e64830a317d2dce83ad07010f11970c4d6bccf63cba9c53796113f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cacabdb1e48108acd4738b7b030d1b240e433783a0a1b6d0e8fc20735e58b8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4fc7432f7e622374f7aedc59312d820952cd8cd14d9f265b88ae206c58c83d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc5b7cd5bd74907bac04e6a0316954e197274e18215fd0b66cddc34093818b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "01cc2b2bae5b4b5f362626d37756efdccf87089f705a55a98841856f7845f485"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c653f9541943f6a11e86db50444b7cf42dc74577332c5a2ab17a9a8f903db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db01dca11b6887cf9428b9d29de8f1637bf380446ec19b1603bcb60773cbb06"
  end

  depends_on "python@3.13"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/59/45/a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63/tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system "python3.13", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec bin/"snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{CGI.escape output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end
