class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b6cf28228cfc509a021a88fd5aac35ba784bbe7c8119a4501773d7e5cb5c4a7f"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "510a79d6acd58e93fd12978cb9d6f05e42b34d702e6b19db1f5675a368469883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "510a79d6acd58e93fd12978cb9d6f05e42b34d702e6b19db1f5675a368469883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "510a79d6acd58e93fd12978cb9d6f05e42b34d702e6b19db1f5675a368469883"
    sha256 cellar: :any_skip_relocation, ventura:        "99fe4105b27b3a126d1ae12aad1078006669e268fe9b6b47c9081a899b7f53a4"
    sha256 cellar: :any_skip_relocation, monterey:       "99fe4105b27b3a126d1ae12aad1078006669e268fe9b6b47c9081a899b7f53a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "99fe4105b27b3a126d1ae12aad1078006669e268fe9b6b47c9081a899b7f53a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "442c3f90af451874d8b326fb16f57a4ba11c255131501a337911ccaa72fedb37"
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
