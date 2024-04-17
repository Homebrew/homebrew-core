class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.57.2.tar.gz"
  sha256 "f6fef3af7a16af93d0aaebbe3ae26d3503c0b3767621074e3894fb8caa2bdb6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98adbcf6fd57bcfb71e456c53292551a6a279a60982987f5e4e4ac2a5e5d7b30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67207d456957d87a4824c8bb8e2f3648507a321203f4dac0a9cb2ebd55afad4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13c74c12697e22e0e491cf82107a5f655e4b5f640187c1ec1b0fd65dd33c4247"
    sha256 cellar: :any_skip_relocation, sonoma:         "32f51b9fc715b84ae2f28c4be21072aa1860f7bcbd1c2dcd46c878ec6a4e0b60"
    sha256 cellar: :any_skip_relocation, ventura:        "cddab96a0b5c32a19a2ecbc45ea4465a916d418ca5697c281407e462cc3a07a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a025f6cd89782952f22944d425d92b2eb579479df3ab288f019709b55f5dffab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9aab22332a41dd27ec36e7a226f028648f1a0e795e1d85dbf1cdcb61189cca"
  end

  depends_on "go" => :build

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
