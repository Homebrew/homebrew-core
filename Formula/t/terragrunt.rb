class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.73.10.tar.gz"
  sha256 "01e8452690500a531f6d14de3b9b9e4f75915647ab3fec602d6c83c54dca9830"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f5502b0240a4f8e5676b596e2709089f5c53cd1f93e56ca274bed19f3274404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f5502b0240a4f8e5676b596e2709089f5c53cd1f93e56ca274bed19f3274404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f5502b0240a4f8e5676b596e2709089f5c53cd1f93e56ca274bed19f3274404"
    sha256 cellar: :any_skip_relocation, sonoma:        "a082eeb832a53486f8e98cc7154e5521fadb731286e25f73799e6893adb61078"
    sha256 cellar: :any_skip_relocation, ventura:       "a082eeb832a53486f8e98cc7154e5521fadb731286e25f73799e6893adb61078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e6137d19269201936a7ef2359a1e42b23e0e241895c8a616a00d969ba38313"
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
