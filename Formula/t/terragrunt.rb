class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.50.4.tar.gz"
  sha256 "b54d9af22f8da5ea5c4cfab9a49b896ddb7ff429c092a5bc53df83786e346943"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24aaffebc5296f9fd9874ca021bbbb90a67b1208b928717d8d1c41ccdeba5469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88143980d53deb1e0a8e26146c4e5f0f19770c62ed8a66ef55b84ded41ef519d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36ffd78ec3810f51eb16c2bf8eb423237e320a9a84cfeb95385bb002f9e8ed5a"
    sha256 cellar: :any_skip_relocation, ventura:        "46a1e9dc4af33b0cb3630a739943a9cbca742473d57b640263573975293cbe90"
    sha256 cellar: :any_skip_relocation, monterey:       "858d09a99a91d9e129022d3eccc65422a6c6f6fe6b2549852b15dbb44b35b1ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4578e8b90ebf920d7d03999c09128002b02fa5e49f3ce988c869583e3fde588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14773fb96c683e54c9c194c19e9c07b39bb5a684d9ce345909879014dbd9815"
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
