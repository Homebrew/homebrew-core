class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "4d70bdd313600df64927928dc767c1e1ba980dcbb0da1cf03e9fa8bf4fdc5d55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c37be7e43f3f7d564b5db804f75911c34ca69296d2d90315a9fcd400de971ef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c37be7e43f3f7d564b5db804f75911c34ca69296d2d90315a9fcd400de971ef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c37be7e43f3f7d564b5db804f75911c34ca69296d2d90315a9fcd400de971ef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab0fd91cabc5782e76398459df757cf34ec43b0dc8736ceb0acce67e5077f444"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a728aa451f2c1a533051fd2585e34a5848fe4d3dd2cc79f01de44d51b17f712f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045afaa415db7100519baf5eb129eecf289702b5208bd7890459060db7c357bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
