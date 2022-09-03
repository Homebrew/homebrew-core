class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.27.tar.gz"
  sha256 "911e15afe9717c44a49187302738d28f5c8f021ef3c338b2c4733f0a15ed02ea"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469a1c9b53a8c08256e1f33e392ce3e504c2eab9d067287b26a9c1195350dade"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35d0842beffc2103ecc8620bdf7f447ebc83dadeabd4a337da8ce583c7c31116"
    sha256 cellar: :any_skip_relocation, monterey:       "6aac2a83467b11f5270ef63ba17f805df37ed05fd08c74bcfe0271ca56ada093"
    sha256 cellar: :any_skip_relocation, big_sur:        "c048ec57745f19119b7523cd6e228e03deb0445b838b9e25fabe8ade994a7151"
    sha256 cellar: :any_skip_relocation, catalina:       "44342ed04e87f51b771c9b704759bb59cecb27e2eed875e894668d2bd3888736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db71c75c76db957ffa81460de6b2da8293ca7ccd974e565c4f1067e958fd6f14"
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
