class Snakeviz < Formula
  include Language::Python::Virtualenv

  desc "Web-based viewer for Python profiler output"
  homepage "https://jiffyclub.github.io/snakeviz/"
  url "https://files.pythonhosted.org/packages/64/9b/3983c41e913676d55e4b3de869aa0561e053ad3505f1fd35181670244b70/snakeviz-2.2.0.tar.gz"
  sha256 "7bfd00be7ae147eb4a170a471578e1cd3f41f803238958b6b8efcf2c698a6aa9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1e8c5454e204c47519daa78a0f81ee26142b3b55461ab1ac0a54a700c5ddaeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92423ff12040f8bb58932da3e85de8ccc9f4a0d03062e38011e50fa58ba4648"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b720d5d592f63fd467d4ce86e3423ea9ce5866548de519db11f39fc768f28ab7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8408abc7756e010d8cd9c4a4d7872b4e9a35f9c80c17ae94d5877e4dbccfdc1"
    sha256 cellar: :any_skip_relocation, ventura:        "e976d6136f4a25ee8f9db7bb7df42c2882381ac88500bbb77ecb3dc695218d25"
    sha256 cellar: :any_skip_relocation, monterey:       "4b76ec91b173fa652dcc1efbcffd14cd9c5c6dcc661c362dae45fc4f5ce4adee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e8caa4e320d0ce6a05b0a8af600efe4a23d11b18d09e932dd94497eb5c0fef"
  end

  depends_on "python@3.12"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "cgi"
    system "#{bin}/snakeviz", "--version"
    system "python3.12", "-m", "cProfile", "-o", "output.prof", "-m", "cProfile"

    port = free_port

    output_file = testpath/"output.prof"

    pid = fork do
      exec "#{bin}/snakeviz", "--port", port.to_s, "--server", output_file
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/snakeviz/#{CGI.escape output_file}")
    assert_match "cProfile", output
  ensure
    Process.kill("HUP", pid)
  end
end
