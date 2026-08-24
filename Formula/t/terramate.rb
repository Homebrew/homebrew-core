class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "697ddb9f02995e1f2fed07c2eb230c47cc85de5f167fac86f2da02048ed695a2"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a4597845f948bd4c5caccce755bfad9d22b3167059c2769925a007ef0e20435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4597845f948bd4c5caccce755bfad9d22b3167059c2769925a007ef0e20435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4597845f948bd4c5caccce755bfad9d22b3167059c2769925a007ef0e20435"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce4c5c9fb43221dc821deedbec6c2cecaa444b8d5c4e809667b8c17420e730e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e687b5d101235e564b8b7bc8a60a9d4820f887e7c60f1ea80e50533e704d816"
    sha256 cellar: :any,                 x86_64_linux:  "0dfb2bb0ae994aa6b418428a50411f1634d339706bba4a7e8fa8a46830b3b5c4"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
