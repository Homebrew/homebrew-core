class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.2.tar.gz"
  sha256 "8362c0e23f9547c3ff95454e8b4c7176b6d2d4273e5def8f50e6cab4604abe02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f263a2adf2d094ae3dfa95379ba9905f164471aa8d51086d603b4fdbea946463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8207a44e41b876b0cecf186235477857c44f4861239b98b71cc17f8eade3f027"
    sha256 cellar: :any_skip_relocation, monterey:       "85d261d1c6610f7c25836f97b2d455d0ec8f0a1e12d1c5afe49c638d3004de71"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c852377945e1862a0eb0997991838a268aded96f12c2b6806abdec8fb72f47"
    sha256 cellar: :any_skip_relocation, catalina:       "b34d12da4f2c3d6dcb037c9dd2ca8db0c12af5ec1e0fd3e8711d261a3a4a409c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac4e657f9655ba5cadcd851d0d8c8bd083f02495ee4537b162b7759cff33fd9"
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
