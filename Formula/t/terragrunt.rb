class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.63.5.tar.gz"
  sha256 "dbb26d503ed49b6742ab3b851bc9c4ca558b824c729c2f64f599f715395462f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8acba094b1fe0b84963b40b773aafeec869b8ef1552e08905df0dcf7deaaae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78276d47d42d5d380581a91f245db7ddaf7f92ef39a01f317f4cf89aca75f7c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178fcf0e033f154a0bcebd097f02098ee277e0def0878a1f8e4545ab65542135"
    sha256 cellar: :any_skip_relocation, sonoma:         "da1ce7fce49589d1bcfea411a54195c600b1996d658f0280715c1f356120330f"
    sha256 cellar: :any_skip_relocation, ventura:        "3c35b6251b82d8196f090c198f5c3097db74159a1dfd0b44c8c9458234fded4f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf07567374b9570966892989cb737013ebf08f1abf042cb40e59f8e6b323ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4adae4840a563a29b41ae00e6d8ae3be2cf7fc4778d825f46272480b908f089"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
