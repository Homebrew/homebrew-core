class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "4c8e1582c9f6847244f16bf2f248fabdf9c6dd98a88d82976157c29e672331d6"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a62e9245405d3cdd28b4896f692d0e5079f31f21e5362b952d05e4517d6069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fbc99e0d129f54124e82f3f59f654e8fc46f3be05ba309cdf0a167b5385910c"
    sha256 cellar: :any_skip_relocation, monterey:       "00e11161fab012626c67d3658b5741c9ad2a2c64ef5800e9e9f7b2a4fb49bf39"
    sha256 cellar: :any_skip_relocation, big_sur:        "f14abf81b991f9eba49f55ee6009343da30ef6326e7c03e641c9f6e56c34267a"
    sha256 cellar: :any_skip_relocation, catalina:       "106228049b8b581e8294030b75e36f78895b41ba8254e3160fc951ee51e454c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576d697511d679af6c14c8520980acc7e803e0e918b4396dc42a915161871bcc"
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
