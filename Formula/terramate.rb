class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "beaa66705260f73d8cf1dcf1a77465ec0cb83587115cd621faa17e7ef5f8a839"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07ed173ee12ad65cbb94c95671c1bd938382c1ddc0796d47354c9e8efe43eef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67a72b9977ded55da0bd358952610bcaeef9bcb2fda7a7211778c29ae73dc6da"
    sha256 cellar: :any_skip_relocation, monterey:       "9474e59f2d79fa11d08876d574cf7c18f66e99893ce9294612039e840994518a"
    sha256 cellar: :any_skip_relocation, big_sur:        "81d18427f10dd7f71c8e836d388b8c43af338673b882b086f1f9913519bababc"
    sha256 cellar: :any_skip_relocation, catalina:       "aaf42ad89ea8303d82ad86991f76a30ac1bd7238142d010aa2d62eb5f082334d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471a01bb37e45d5538344d5697c31e9827f21673eddb45e189fcf84b2834e015"
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
