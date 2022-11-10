class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.40.2.tar.gz"
  sha256 "b93899520fc944d2a46abf5f310447a4886d059622f867d768e8ddaa3ca0f18b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f77a2b49012a15f3536f2a46f345309adfe4218777592d953664f8902eb8887d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7fd02fe20add790113701a1ac7f5032dde6ca9f6cb0e8cd46e814ed6f023de7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d7a2caa41864305e4d8312284e8807f810579445685f651ff4968dca3d60948"
    sha256 cellar: :any_skip_relocation, monterey:       "ef21a376d484f46a152f1946be5e4c60d87b9c502cd91360175a72332080525c"
    sha256 cellar: :any_skip_relocation, big_sur:        "114d6cda3da816bc4bc3f8d548f236f1679b576788b1703909e963c1bbc88aee"
    sha256 cellar: :any_skip_relocation, catalina:       "4848c5276c609e1925c46c97fbb3d8550919864214bd54cbd34345d55d84572e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab580a916c83de21fb79139624776df7c787bb0d71716755383c06b275067141"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
