class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "289255ef356cadff97a8cf3726c851f6b62d3ee4ba31a9b0aedc2ea017f9bc52"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d03417b1d17d51e2d91369c9f0ab7e7a1499f0648f1dea1cc88f7a784c77a40b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c05b47cdc0686f5ad043080a7c26e910ab54e8240f494d0cd7ab247bb07fa363"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f4ca83eb1da538ee2ed9b0cc93657dbf46eb2a2861b57857c445dd6a040ccc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "201a8ba60d42fba4a063dc46107bf5ddb729ce55f4b0f888579f80a501a70f44"
    sha256 cellar: :any_skip_relocation, ventura:       "19c65572a1babe94a2c54c25d4e14a5511971272558ca7c18cb1221426184dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30c42150478545b48e3711a0f5f34ad0c620b9aa59987882c25b4d2f46ae10b5"
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
