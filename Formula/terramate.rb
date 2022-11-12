class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "4bf907ec3a49069b155c8fe03412dfc3346f3849aed1685ab425b68186833950"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d022981fc80378a15b75ce9994e8bb32a898699f3198489cd328db03dde335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1283e528ee1059b9283edf96170bb5a48438017535edfd5806cb4037b686e1d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05e9f9edab0b526208776e34d582dbeb6657cf33ea37015b7103192c1cd2de64"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1e9bed5a63614c89bd2bb64c4917f77bdbbf18e7a7cf8c7f0fb7afb16ccceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dbe9beb3f1463f0d32c5160090636b870deb406e19f748c670fd52e4e224bdc"
    sha256 cellar: :any_skip_relocation, catalina:       "bbc7d272962f69b08dfda60b0e40d9fc50efaf61b6d79cca8daae5ed52828dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c5ec232816ef199582396f3e34f77c646200b457a8aae1f7634dad2e2e25b3"
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
