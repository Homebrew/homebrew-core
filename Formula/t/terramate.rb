class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b400187c5481f083010a659f91a22a03ef786dcd32735f01d07f12a9efaf3935"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "263917efe5ac55fb415f96f3bcf5f25d18ffca8a54554937bac5adfce2720366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "263917efe5ac55fb415f96f3bcf5f25d18ffca8a54554937bac5adfce2720366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "263917efe5ac55fb415f96f3bcf5f25d18ffca8a54554937bac5adfce2720366"
    sha256 cellar: :any_skip_relocation, sonoma:        "e36c6dd8ee0aa8af981bf23990c9c694e88a81c51580e6746903526d5b2ea9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fcb1501717fdf8f21222d9c7eebe98de6d48fd34087b92ae280761775f67df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8936b942af15710f4fa711b4a377d306636515cb6b36a8f329e6af2563a02c7"
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
