class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/64/9b/3983c41e913676d55e4b3de869aa0561e053ad3505f1fd35181670244b70/snakeviz-2.2.0.tar.gz"
  sha256 "7bfd00be7ae147eb4a170a471578e1cd3f41f803238958b6b8efcf2c698a6aa9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "188ce42a3ec12499676c82b4eddf04d412f9a7493f50598ce1ef6ddefdcb8a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb6ff65e7ddd81e4b4da2ce4d2f1c4d71d66bf7afd244cb06704463655e39987"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eebb8d59c3b7484eb42f3d6f4823bb76e60e8a07f30b040f42f57c557a0c1c12"
    sha256 cellar: :any_skip_relocation, sonoma:        "684df7298ea85611dab2fd8019e643ec554f8ec85cf0c9eef16954d8ed87b1dc"
    sha256 cellar: :any_skip_relocation, ventura:       "4b9c89717342f4189849008929288963b28e26736c2d35777b8827903a288d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8b886c75c192f230dfdb4b0b820e353cc24e8272cc66dcfc1d0deba90455b8"
  end

  depends_on "python@3.13"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/ee/66/398ac7167f1c7835406888a386f6d0d26ee5dbf197d8a571300be57662d3/tornado-6.4.1.tar.gz"
    sha256 "92d3ab53183d8c50f8204a51e6f91d18a15d5ef261e84d452800d4ff6fc504e9"
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
