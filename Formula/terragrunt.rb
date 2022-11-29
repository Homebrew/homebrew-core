class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.1.tar.gz"
  sha256 "635e75e4d9086e3cbbb2404aaa2386a75747097717ac4f0213ee16a9cbc9c968"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "656931808014c64c6a9bd02ff753bf29300d86a1dc798d8d6b30c0f49f6a55ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6becd13d029f0fff4049efcb839c996d887bfe890f78634fbddab5ef4d456762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e73feddfb3d9c6d8a1319d4a4eb1f7898c0be1c4d6df5ea453fbfe3e251b706"
    sha256 cellar: :any_skip_relocation, ventura:        "6b65cc202a5fad9b8faafde631b53f24c4c89aa2e9f622ce4269cc659b5b35d6"
    sha256 cellar: :any_skip_relocation, monterey:       "b557e3fbf46e5bcc4f0bef126d67744989970995e24d7004213d7b103c14c55e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c168281fe900ed7d90830178f3b79135d61a0ae32f23d1e5cda696bd6c971f0e"
    sha256 cellar: :any_skip_relocation, catalina:       "41ed70cb4ebe0d7eb19e2748ec48e822ca670ec5b24695bb4c54c3376aec679b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd789032f59bf786fec475df8d682c72c137fbeff0ac565a631c0b73d4e32cba"
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
