class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.20.tar.gz"
  sha256 "eeb81d773b8fc32a61a13738a146d1464ca82584b536cd73cc7db6edc5e08ca4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b774ebb77278b9b121cd0a55b85fe62252459b9ce726c7f5f2d02c8e5980512a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164098f497cb672cf366196b2fb9977796101c03a55cafdca0ca35ba67bf9632"
    sha256 cellar: :any_skip_relocation, monterey:       "42a51db7bf03211da04b5ea6095a6ee1f358e8c0888448d6ae01b8ccbedb2a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "88d98949b755e6b41f1f0cf86cd8d8dec09a3e7bb19192fec85c489a7f054099"
    sha256 cellar: :any_skip_relocation, catalina:       "71d003a4ca49f021c645c0accd1e40536bf10e7ef86f63325d935926b982920d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c995988362e8e569f6ed8cf38be654ec0561796caa94c706bd14869187823f3"
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
