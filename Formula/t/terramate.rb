class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "4f14db63677de54059410c6ae3d3e911e0bb4f54eb5e1a183729af09c125c73a"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84754c76c076eef36c167fe8ef8da4e2bbf9e8391e1930c66124471b8064ecc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84754c76c076eef36c167fe8ef8da4e2bbf9e8391e1930c66124471b8064ecc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84754c76c076eef36c167fe8ef8da4e2bbf9e8391e1930c66124471b8064ecc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff6b2f6dd798d3b14ef8bc0aac018ddc0c7a1089025a236a993b33e0a973e81"
    sha256 cellar: :any_skip_relocation, ventura:       "eff6b2f6dd798d3b14ef8bc0aac018ddc0c7a1089025a236a993b33e0a973e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5528d91d44bd85b48ef42dcb094f8c9db6ff084f8ed638779d23ee096abc1b57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
