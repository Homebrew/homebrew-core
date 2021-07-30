class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.2.tar.gz"
  sha256 "8e64f411050b3cbed31a76519e9ecfb1d58f20ac829fef6357cc8e86a416b843"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed47072cc5045e280aa9ce19e96d6aab8998218e6ce685e1ac3b8f35bed25bac"
    sha256 cellar: :any_skip_relocation, big_sur:       "47aea069f1d97965ea7db388468bbd8ba28fae77bde82d6261db3cc3a96e8ec6"
    sha256 cellar: :any_skip_relocation, catalina:      "50dec7e212dccffb721f68ae028838f1681edcf576151abaa8b02c22a833df1d"
    sha256 cellar: :any_skip_relocation, mojave:        "0708835bf2109c0230b7b9dd51a5b068135e7338eb6cf071f5b169d793496123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c719d27df27c1595124a9a36b3eae2d824351113f87453efc19eb4ca68431ab"
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
