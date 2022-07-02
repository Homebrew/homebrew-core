class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "5619ef4a698967895bcf95e58a4f22126becedaa05a2ce88fae550a155c47762"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f058504e939a6ef8df768ddf46deaa53814e68f4e0d859a55a774c7af1d302b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e75f9ae465a6aed2342f07940a955f6b82403cb261fded4a4c2a23f542806b3c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d4a895f031ed274f9fff96f82d0fa2fe7c873fb0a8994d245165c8bf0e01134"
    sha256 cellar: :any_skip_relocation, big_sur:        "7199ce905eb2571b2f61728cfb4fc10e2b1f78aab4029b01a7521f31f8cb4932"
    sha256 cellar: :any_skip_relocation, catalina:       "59232819dbd09a13018c3408c83362efe7fb95b0ddb730fc88fc46485dc851ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45dc299696d0d61b381ff45f1872cd6fe03a7ca706135bf6ba008df470ffbf9b"
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
