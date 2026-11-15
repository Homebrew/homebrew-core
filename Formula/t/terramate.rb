class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "3f95c5d24efd57c6af8935ecf22461b17f1a8c9867bfc1269cd8849e19910cfc"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08e2a9fbbb7b727edf4b9aca0558ba7598e51bf130193598945324b60525ce61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08e2a9fbbb7b727edf4b9aca0558ba7598e51bf130193598945324b60525ce61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08e2a9fbbb7b727edf4b9aca0558ba7598e51bf130193598945324b60525ce61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54df88aa1e093a1650541e1a26e8320c5c0213f51f642300040091852c504341"
    sha256 cellar: :any,                 x86_64_linux:      "9b3c0884a2bdce571b3508b24f36318c194ca1b11d1e4bdf434b38ebf79de2d4"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"terramate"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
