class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eefaa7c2dadc370f5ccca63450201f68b10163e61d6dc50ae3c26c16bd686c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "318c17f514d98735d7577c6df4229ac07e50f83ee24149412c096c62dd4d6235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc79d16f3d26870ab474010e32658e3f042a12726ea82e3899adf75541d25f4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f619789876c65dd82de1630d89ed6fc4cb9521d67c15d9955edca63f00079dff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333d060ac20fa6c1ff54c80a5bb1243187f658fb60356bc56c47c2c074450bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db4646f3bcfb62c5e601aa8e14ea8bbae28b1eefab03156f80764acc2778cc1"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/09/ce/1eb500eae19f4648281bb2186927bb062d2438c2e5093d1360391afd2f90/tornado-6.5.2.tar.gz"
    sha256 "ab53c8f9a0fa351e2c0741284e06c7a45da86afb544133201c5cc8578eb076a0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system "python3.14", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec bin/"snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{ERB::Util.url_encode output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end
