class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "cfd88fca001c74e7c7a3241305b30b0ac1117e8967638da0d8ada97f152691ce"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28aeb1beac712049924e53e6825bca5f2435bc378e8a3ef5a18cfd26540c37d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8dc835041cf567c65c3769d41ffac4ede251ce148748f082ad397f1237501648"
    sha256 cellar: :any_skip_relocation, monterey:       "c1fee271b18be55cf14538d606ec4c7f06e9a73703397edc0bbf192b95e5579e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee9d98572d58cdb8d35d10eed19400a0511132bdf4eb9182a41610f8aa23011d"
    sha256 cellar: :any_skip_relocation, catalina:       "d697fc4a0019b57f3e78f41bba0b7c36ace5b2cf3326913768a51b79ebec4a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acae915950b016196437620e7ac7c8b6568bfd2080999270c65fcf15ddf6b0a9"
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
