class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.32.1.tar.gz"
  sha256 "356336dc500a4b0b7529aacd024426cd15ef27641ce591722c0052a80a9035b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f82df6b0ea96b25a41a6f68604be7a19d1d23532a690c0ba2fa2a35c5b48a184"
    sha256 cellar: :any_skip_relocation, big_sur:       "e79038679da1298f78c5df82c23e10574cf09365c7ded00a5198370677dd37c6"
    sha256 cellar: :any_skip_relocation, catalina:      "505cdbbf49be46edd2534c04d10a5b3eaeaa347aead4d07de1ccfb9da76aef42"
    sha256 cellar: :any_skip_relocation, mojave:        "6489aca93caa6e8639973d3f4b3203e9f8a35587efd49a67857141c36a313426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11453129bbba0ecef9e59eb945ceac07f3d49ecae63266aa70c57d0dda9f8d1e"
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
