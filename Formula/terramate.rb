class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.28.tar.gz"
  sha256 "e45356f619793ef7fe9b7dd41a419de253992612d0c056c0a6bd7c6b309d6c0b"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28f15ffc5ea1a515e07b8014c39f53cad38d56d38f4ddc19b236ffe8262c07c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e81baf4236ef5e67964c656b2239ed1ea7298be23b3daa858a7200740d3c69"
    sha256 cellar: :any_skip_relocation, monterey:       "12e77b50926ddf23f4d7ba4beb736f504287338480f02aae8294659a71d665fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6043d7a961cb300c920673149a95d3d10725a827719f15a5aa2ac874e561250c"
    sha256 cellar: :any_skip_relocation, catalina:       "a9f9d132916ed029962b7aeb3a53de29abaefeae27bfa913c1169506011a9895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec946b21a9e6f6076254d086e9fac45898d12cb8da1affae5d99040279fb1a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
