class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "80ac556aa787f52f325fa2ae81aa32d91e0c96ea54f5782f8e8f2fd22089442f"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40dea1d2f8bc632b06cddce87fe7147ecda4296fd894653179b5fb330838de92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b98fe18554b9ed4f75153c046f69307a1805fd76de465d6bb3cc88fb2974142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae889c6203c487b0f84f5f4bfd3c1816df528a8f84c05c47ed9cad26dde8b78c"
    sha256 cellar: :any_skip_relocation, monterey:       "852a6e9521d158e08ca7dab65a00a48c415d637ad1aa5d0b7c2dcf9975dce5a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0e1ff7d37449273a01878e556cd82e8ec2993da7809d2dd9c98d26fdb5c88a"
    sha256 cellar: :any_skip_relocation, catalina:       "3c368c3507ee7385653a51752a112703abfaf725abfed7e7479d9420b2396707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e13c54e85594310b5bde51e614bf664ebd99ec4b78fa09cd1bd97fd04f4aad2"
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
