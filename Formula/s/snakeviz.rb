class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/04/06/82f56563b16d33c2586ac2615a3034a83a4ff1969b84c8d79339e5d07d73/snakeviz-2.2.2.tar.gz"
  sha256 "08028c6f8e34a032ff14757a38424770abb8662fb2818985aeea0d9bc13a7d83"
  license "BSD-3-Clause"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0d9d7598fe76d47804230dbfe1e87afe2a3fd4802336e64258d98c98fffd81b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "545312b44c723b1d2f014bc4472d743d87044f2bb265de93f89286f739ec7835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab01af3b2c4975ac0abbedda8e40a95f592cea7d028318cb909246875b6a508e"
    sha256 cellar: :any,                 arm64_linux:       "bd596a2409618d84b596e2f60545c8b4839a614fe16ced141ea4d565691e5f58"
    sha256 cellar: :any,                 x86_64_linux:      "fdd6eb72b7d149506bff521c5dcbb517cf1c0110f6640a82169355d9291a0204"
  end

  depends_on "python@3.15"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/06/61/53d562a57b28c08eda40b258c0f975e360541943ad7c7bef897a40caafda/tornado-6.5.10.tar.gz"
    sha256 "a6b1ccd08c04b4a06fb5aeb381be99de5ad1e5375c1785e31d78c880feb57687"
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
