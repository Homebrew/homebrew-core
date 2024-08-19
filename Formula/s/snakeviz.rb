class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/64/9b/3983c41e913676d55e4b3de869aa0561e053ad3505f1fd35181670244b70/snakeviz-2.2.0.tar.gz"
  sha256 "7bfd00be7ae147eb4a170a471578e1cd3f41f803238958b6b8efcf2c698a6aa9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa7305a6deb93e6f5659181b44de5d0155a4220a8b390f542308008478b112db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4a0b2bf73dd3a2e0400b6a2623ca34cc38d3d59017f5584324f3c2698fc6d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94190c13027e896e8ae9bb85e4ee3a76c4a93170b46875781e0ba2c61ce8a4e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad322f258ad80a9a34abee4555ad4c5fbfa612b70b03f18e19c0b07593f519ed"
    sha256 cellar: :any_skip_relocation, ventura:        "f834932028976a74ee9edbc4fc9250426a754cf153ef28b04dba6843484406a8"
    sha256 cellar: :any_skip_relocation, monterey:       "758e512224f61b752d846d70c0ea628eb18cf0ec099b195fd472f8370a2c6683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc336d17fcdb88dd008ace56a09467c24aec73841ed063b9f2ccd2ff96b2a36"
  end

  depends_on "python@3.12"

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
    system "python3.12", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

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
