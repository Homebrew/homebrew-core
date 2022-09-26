class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "0de16359b5f062d88f292c0da285cc189e2692d38d7d10babbd70eb25243fd17"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f178385376f378e1b0e3c3e250e694fc0b6d399bd4e5843948c0e339480ce27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9a565072b6116f8da3a2a9f0b5a4654977f5bed29b648d1426742796d21c0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "6599c8bbdb8b2962a1caf623d0732b2ed1a6edde76d30082e17b2dbb56ab749a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8a1d04347ae6ef4fcb004243bf7bb8573f69e543008f4a5439c16cefa1cefb8"
    sha256 cellar: :any_skip_relocation, catalina:       "b1038294354dbeab268f72de74322401427741eeb29e3b385e6d4071ce3afe3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e99e13afc7495601b8e5856212592679edf83b715bfb5452a2c648cd66f227"
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
