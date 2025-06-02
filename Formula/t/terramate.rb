class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "fb9dfeb7395e10e2000ed67ab9a6e40edea6d31efcc9f5a84a95f274cb9ec8b9"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311186c426b93f86c20e4db5ea99a1c8ee5eceef67f30246543b619eea7bc30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311186c426b93f86c20e4db5ea99a1c8ee5eceef67f30246543b619eea7bc30b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311186c426b93f86c20e4db5ea99a1c8ee5eceef67f30246543b619eea7bc30b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4873d7e9e964e06ef313ec71d9a686bf8790f9b5d7a552dfc730382dd5aeaadf"
    sha256 cellar: :any_skip_relocation, ventura:       "4873d7e9e964e06ef313ec71d9a686bf8790f9b5d7a552dfc730382dd5aeaadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc0efccf3289fe0b2996d9917dcf487588168e97fa7ca0501a8bd5daf91eda6d"
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
