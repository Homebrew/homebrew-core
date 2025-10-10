class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "36d71ed54634af2f61958bcf139db5509f1307064716fc1aa180ab97d3a9b668"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85696b980c239adcc6a0c72bde226cb75ee260bef0f4ef510d660d58f44260e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85696b980c239adcc6a0c72bde226cb75ee260bef0f4ef510d660d58f44260e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85696b980c239adcc6a0c72bde226cb75ee260bef0f4ef510d660d58f44260e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7c71fcee8c316625c0ec526e21236c913b1ce347e84d8cadb2917d9c9c7d255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4deae325bc1095d5e474e786258270de3c1ccd45b9b1f21abcf6201358ec15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12442e853b2b354c045cfad4fc4ffa00189590a9ea37025b391017610f0c361"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
