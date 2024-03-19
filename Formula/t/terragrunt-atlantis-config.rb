class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "46020214f4c1095bb80e837edd3a97194b7176e1502a7e3fc9c6c33bb1188d5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acc50eef5e81fc5bbf69bcd198da3e7528574bc6f457773977ca05cc9a2f250a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23cf5d2c59aee63e4e200b2c3d165b8e51bc82690e73ee14cfbb55cd13446499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e5494e6a09e03a21863403b35530d6d927935c835e7c197ecf6abb6a547c1d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f080fde421d7d0cde670b602fb6dbbf3125f5d4bdb3cc9ab5bb85279d7aa6544"
    sha256 cellar: :any_skip_relocation, ventura:        "9dc55d764b8524f81be173da3a227963b38ffa24f6c9d9494dacb162fc4e44c5"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d35ce74cbc2a0b21c395daba5a15451e93097d6119d1a0e5cb2a785f2d248e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1987c17152453acdc07b481832820a7fdce8ceee6c7e2717c1eaf8a99fa37a84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
