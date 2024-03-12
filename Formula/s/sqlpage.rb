class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "edd1150550525bf4ac9f67bfb32dab89f9d3e5f9cffd4127cc4cb83ad9020d58"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5be259547c0197f7629c2a0ca1ea6a9235756b7482e063fef7fd49400d28011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a2e51b6bbb097dab9ea546bec7bafb1ba09080ce25a419820f95b0cbc66f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "482fe4b96979f2b9b1700eae8284da261d670f9b25bd7bd336cf115644f7218c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c01223b81ec59aae89ac6400c77a10c015c3a2193ed402e606df7b863e4f35a4"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3ba92f3276c0a32c7115910bbb91b816c38b275ed9aa46f1a308676b5b97c7"
    sha256 cellar: :any_skip_relocation, monterey:       "53e61ac550dccc874c7837985eb081c1c41b1784dc667015b0db4a01bd397e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca28664497929d8ca95467d10c5168ef5e23fef9dbe80ffe102bb6c91f2a0bfa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end
