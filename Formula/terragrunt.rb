class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.2.tar.gz"
  sha256 "8362c0e23f9547c3ff95454e8b4c7176b6d2d4273e5def8f50e6cab4604abe02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f23ef447719aba7f7757008939a1922248529f1fedeb5668ac84cc5047be3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5514bc5c6c24b67a4f230670ceba1c903519e09084f111b4109af1f8d5dda61e"
    sha256 cellar: :any_skip_relocation, monterey:       "41764ccca87b3591164ee83d5b2a15c28bd985ac7137c27062a017b2ce7e9009"
    sha256 cellar: :any_skip_relocation, big_sur:        "9326ddb11fd4b407b9b4a64dddc5f813a39715678fe2bf59fec337d43b297960"
    sha256 cellar: :any_skip_relocation, catalina:       "2d415e2a59c4f7cd60257b62efacd98a8ff973418d551ae63982b7b6aa445ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18173793f29612d461a1d471a016931b5ec27083218c30e42c4942e37da0e193"
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
