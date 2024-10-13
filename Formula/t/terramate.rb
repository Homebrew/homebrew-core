class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "6d9b410e3a9d7856d2ee2b8d3abf155b913016843a1d70dd870784dd0f23cee0"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f225b350077656e2c5943a03f918bb7e8129201ac379a197244ed17905d9e3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f225b350077656e2c5943a03f918bb7e8129201ac379a197244ed17905d9e3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f225b350077656e2c5943a03f918bb7e8129201ac379a197244ed17905d9e3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db4a60d56ee8229c6b3c24724b2d7866bf1fb86ef0f0e2c25a1753ce747236d8"
    sha256 cellar: :any_skip_relocation, ventura:       "db4a60d56ee8229c6b3c24724b2d7866bf1fb86ef0f0e2c25a1753ce747236d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12a6e284d37f7e180e992c38908d71a1b4744adbcc460e0b42adaa5a0472811"
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
