class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.24.tar.gz"
  sha256 "9da8a08aff6ac2efa7c03eea64ffe4619b0c5c60150b54f5cad4bef3daab8e9d"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a9f0057709bab32233fbec56360b8f9e140d560a5ff1c1a2ee711a439b7c103"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3daa86e920c1165d681ab7ca722008ffb338c4338bd22c017a3e49fedfa496e6"
    sha256 cellar: :any_skip_relocation, monterey:       "77fb24a6f2213125680f96c99dbf7c8bac9f355194b0aae76592b9a243579847"
    sha256 cellar: :any_skip_relocation, big_sur:        "864d60a523ce48588a4110f62a399c09d683136e1cb2f53f064f9516aaffbee4"
    sha256 cellar: :any_skip_relocation, catalina:       "a54b44b955a1708bb2d093236a466e7b6c3e04a2159d726e9c10088ed68d8af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "475a81c46ee4425f44e66ba9cb642f7e26b6a8e41905b6dce4c381f98b8bc9d6"
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
