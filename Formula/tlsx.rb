class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v1.0.3.tar.gz"
  sha256 "258bc30237df83b3e2fa01952246d51adcb715bc7c827b3119eabbb45df42717"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "569f457413c7d281fd134802748a60ad0d6c2d31fb2c694d44358e70108c9d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de7b0820781852d8630353058d8d94bc148500e1ab23c894c5b8f038db035f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ebe58b060c994fa16054107d98d77d449a90215d81ec67270c4bc41fc2b964c"
    sha256 cellar: :any_skip_relocation, ventura:        "5b13d2090a4457266987d85877ef0177496970c658dd2f76452cc501d886fadf"
    sha256 cellar: :any_skip_relocation, monterey:       "cb10dc7321db582945668a031572fa7beef014e45a6f810409edc5fd6d769d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "be6a83b6f64ce3a85446c8e37673fc7b6a00a74083f08dc31c2e46305cf487ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b3dcb1b393e8ad76b040daf82ffe967a10eef1005d4b95b04381a0bc1e0f92f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
