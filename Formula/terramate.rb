class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "a02c954a93a2074eb39a62f9397dbb99ef4ff2809e20d9f45ae9748e1e9cac95"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c31e11046b19471da008d8360b41c7e096f629746ec9887de98671b6f14309"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ff02023db79a7e116040d4c39effb6b185caaf060714e191ea90b4201b754ba"
    sha256 cellar: :any_skip_relocation, monterey:       "7bafa8800bbfa8f4eff0c01e52cf4e25e443b6f3dc0b3269372b95aa74a4bb77"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bd89ca8ba67e03844a9f9d13b01cdd3fcb6697cb067685f46fef554f62c1558"
    sha256 cellar: :any_skip_relocation, catalina:       "9f33251b8e74d0619de293aeba8b63e11fe9d3635b9accf2f5e969743a0ec3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc9dd68dc25ea8f586a556daec2eea199959eb2f0ee029940a698659b92c297a"
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
