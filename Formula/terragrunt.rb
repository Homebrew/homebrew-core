class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.34.1.tar.gz"
  sha256 "bad7c877cb55d35d4e95c29f9e540b1ee4a85871f6006d3eed53a238ad3cee6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67d4278d1ed7a7990f387071507d38164ba9ac130fbd0c5a36521cfff06c02d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "1b14adda1bd50d9b1c3ce5f656cd9d2c6503f43898b8cc5592d44dfbde73e406"
    sha256 cellar: :any_skip_relocation, catalina:      "72c785626d46a89f080c25ec2c24a222a9c0b0af0697d5a9a8461d495d382f61"
    sha256 cellar: :any_skip_relocation, mojave:        "8a2d0171a73ca6dedeeec7003145076f19baeb707472bd5aa2c6f33fbbb17425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e850ff2f03987c8809e38d93bec07fa2be6c6236d08f2fbeb5f5fb65dac8ea7d"
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
