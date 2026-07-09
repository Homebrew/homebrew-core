class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "80e5e8531ac53a24b4acba2ab96e5ab33ecc137a3e0baa97caabae0c859b64eb"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "937dfb59d308649b9dad605f875d92d97a4262daee495194aab764ecf1c7ca7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e839878fa489ad9b6e31ee48b937ba514f4dd8399794d7bcc38aa2ebc6dab0bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93ed0cad4bca2ad3d72b4dcbeb0d875bda1bb8fb9573e66cdc90460106817fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8a78f3419a921cfefadb7c15dd4c6095fe9dbf06ac4c717f4ee761a0f66fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed11df859cbcb41a7f91cb0b71b0eebccdaf17e3d0b1d61911ae2cc308630a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa51740a63065b183d6617a77bd614ff1906b907da814ff3046a3daefa11c3f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
