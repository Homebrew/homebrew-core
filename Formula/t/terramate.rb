class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "b783e10d2045401fa42187b58a759d8dd75035ef9811befe9c4a4f788bddf61e"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4ec274b3e34503698d1001bbb57f3914264b26db9db2ed6ebdbf6464d403ecb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ec274b3e34503698d1001bbb57f3914264b26db9db2ed6ebdbf6464d403ecb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ec274b3e34503698d1001bbb57f3914264b26db9db2ed6ebdbf6464d403ecb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4ec274b3e34503698d1001bbb57f3914264b26db9db2ed6ebdbf6464d403ecb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62450eec31b10129f6801bdb28f168f67747d8217eda08d26d035790f6bc00c3"
    sha256 cellar: :any,                 x86_64_linux:      "639ace00b028e3b628bce925d2d245014cd4b632b561504416c8ace6fdbceac8"
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
