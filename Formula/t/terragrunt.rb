class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "793a445e2820d3592f292c6dae979a3d31d25acaf2619af42f294c47a1cd34e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4913c85bad754091aca100431d5fabfd815457b6729f6c613a22b4933b1aec4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d77653136b2f8c45fcc2d3c5894e8b6c29f2090064b6c46ba3f9bd5ba22999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196bafb3b7292dc67a5d963d91b571b3f33d3e1ad24efd934f77b8de09d2d71c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2973466f8dba2a8b6701371c44001d8c643641ab471f2ef22cfc13040a7a8fb"
    sha256 cellar: :any_skip_relocation, ventura:        "787f658df4d86b70a8b860ebb64a88138868273dc82689d6ea9dbae7622a0128"
    sha256 cellar: :any_skip_relocation, monterey:       "cf28c7df83e13545fb81a88acfa2d723842ee2d2cf7aeb6d468f563eecbb6b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11aa142be1b34f790dc7d3a694d0e0cf4e9cbf7aa2f7887300c4904b11d000a8"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
