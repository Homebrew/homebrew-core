class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.4.tar.gz"
  sha256 "f3533f36bfc1009a9bcc24505a0d2c32e6a15459312dbb1e578d2cb6444e0341"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f419b5151a1dae564fc63b2ffcc173e3d60601d4e87133bcea0bfb9f04961523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76b4aad96198b1079be06df7b076cb6d8db8d18fd6505cab06a6bb1462d7b03d"
    sha256 cellar: :any_skip_relocation, monterey:       "c54042bea6aad527ca74e9d70cceec05c7ef84d1e75bc7bdbaf27fe05339df6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74979447a3085389f01b66dde31680c6ce173e2924410852b3e71825ccdc9155"
    sha256 cellar: :any_skip_relocation, catalina:       "35692611f07cdb71ccbf454e183828fcb2837c50b6bdbedb13d79649a40ef9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d331f7d6cae596342a77281da1a78883ef8118255f8d8dd37df866475024712"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
