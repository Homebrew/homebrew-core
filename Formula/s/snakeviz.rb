class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d4520c17ede830a4b318dc3e58676447f2cb0e5810ad8ebc4cf28cc01d090d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac8bd6ed2a0deb2b93c66d3f7a1e7d45cd97ed3401644100ca5ed5bb6b99c45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e0e2b75a9317bdf6f00b62efd40979d04ef3cb7d9d09fb4fc5141425e113bda"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f50659ccb85e4fd236fbbf11c789b14d06e79ea0e01ff9b99bdbf8f503a9ab"
    sha256 cellar: :any_skip_relocation, ventura:       "fe459ebc55f218ca933081e52990141c0ed1c83f8dd92d1b170fbd6e188b1a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69f916e637ecc77844e6ca4de1bc87abf662e112f13418e2dc561d44e649ceed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704638b72520fd6f9a35b271b1a428a0fe2afd82958e06297ccd7ed609af03ff"
  end

  depends_on "python@3.13"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/63/c4/bb3bd68b1b3cd30abc6411469875e6d32004397ccc4a3230479f86f86a73/tornado-6.5.tar.gz"
    sha256 "c70c0a26d5b2d85440e4debd14a8d0b463a0cf35d92d3af05f5f1ffa8675c826"
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
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{ERB::Util.url_encode output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end
