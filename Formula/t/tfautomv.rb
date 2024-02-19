class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https://tfautomv.dev/"
  url "https://github.com/busser/tfautomv/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e45cc34160e6ea89e41f07126174fcb5e01ec28263651dad1bf703343e9988f9"
  license "Apache-2.0"
  head "https://github.com/busser/tfautomv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4915e73c7e998c470165924f66f0225454e170fefad11e4b6abf92b65419fbee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4d1cd5219eb4d9ad4f1a835d513190d262ea1acfdc93f1d47b38f9298a5f00f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0955c21c3dcc781fb8d54723a2676d79f8a0a94eddf424b9f10e6cb62e5fd74e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9639c99c9393ec05b7b76894dfb667084c73f82c5a4b7b4a61cf4e0b03040508"
    sha256 cellar: :any_skip_relocation, ventura:        "bb51406a75e4ddd8e1756c4846cb85927b892679ac7b12d79b95a6b524b04c77"
    sha256 cellar: :any_skip_relocation, monterey:       "ba46845e2a03b8ee43fa048d7e2f01b100592570f3f54c2597bed0091e8caf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9d8d396746564db9bda44b79a675890efe22b03b5b5c95efc99200a4fedb2e4"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    tofu = Formula["opentofu"].opt_bin/"tofu"
    output = shell_output("#{bin}/tfautomv --terraform-bin #{tofu} 2>&1", 1)
    assert_match "No configuration files", output

    assert_match version.to_s, shell_output("#{bin}/tfautomv --version")
  end
end
