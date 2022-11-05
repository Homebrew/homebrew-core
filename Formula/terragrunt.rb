class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.40.0.tar.gz"
  sha256 "f3117d0a3afc10508bfc69844ef3361f68d8a8122b175e01cf873ddaae036ce9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a88a913a124bf986491616e63e3b769fe3b4a701a431f2614e9e2567b246412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbbca1d03ed58b4f98a08797280303badddb39aa680385ea97a6208d465d8bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9b8df569c0cacb945edfd66001bfed73e5e1726be3f212e004e6addbd3e64ec"
    sha256 cellar: :any_skip_relocation, monterey:       "86e54775301c5bc8a33be1e4b78e738801cfb3b0001beae823fe9b0a446b9d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cc2ab5c4f1b6b2478cdf68b0ecf20376bf4aa89415fd2888d571c252fe76e00"
    sha256 cellar: :any_skip_relocation, catalina:       "9eaace96b2d91501a1602450763664e4ac31c7206532cbe3eb6d782dc19c396a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1442c1b4eae8a1e6930ba6dbce28a4878c4be4ba05129d5dc36fae3eed6bb049"
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
