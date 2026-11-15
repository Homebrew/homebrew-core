class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc2ba725cce1aa3b3cda0615c358300f1883f2909884afeb59c433e176b2d1af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66a1f65d1e8986240638e587bba4c04a9baf896c9b980e926acb2646062a3df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e810bc1c4857ce699045640cf75d1d56bc8a5ae51d1d58429a32c138e0e2b523"
    sha256 cellar: :any,                 arm64_linux:       "6d475c8e426158ee69a49b159a88df5020b1e9d6bfddd0da95d5fb1969b22cb9"
    sha256 cellar: :any,                 x86_64_linux:      "b818262bc200f6535e97a03516fbdec52c813fdbd74148a756b07f873ef6f4f1"
  end

  depends_on "python@3.15"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/2b/8ff2b41620cbba0eeb0862fed21dcaa5a2ad36c6dd9bb465f9ff7a147be2/tornado-6.6.1.tar.gz"
    sha256 "28e6311402af59c8b02e3fa0f5e7d8eb465b25081381803b127d97e6a4395d5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system bin/"snakeviz", "--version"
    system python3, "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

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
