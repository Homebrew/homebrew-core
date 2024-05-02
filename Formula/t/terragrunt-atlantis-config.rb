class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "6b0d26b611836c121d19b6800d59ec3b705dd6b65f5b353f104337e171c16976"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d02ff6a8a53fd34d4a521381da440ec773f98dfcb062fcf615df2cc88f5deadb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d529a165c03b52d89fbdc6b188db30dd4b10dcce8cb2c28cd1e47132f86c263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff99a9e35ba21df820b3e57b95b18a71ef1fa3511e1afda44877147e53e590de"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c1fe4342db8e73e096010cef6ae63759e0a1200179e2ae83aed6eb2c77d542"
    sha256 cellar: :any_skip_relocation, ventura:        "e9b54db437f82455391b84b8eb284c237863f06bd7bf5554f3c06e83aff06a93"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb47c9243511561b9efc56f7dde315a447c3f0571bcd9f6e6fadd61a106ca41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789add0637f8e22d11aac2edccc8003ca1d8c8ffbf8d9af9b009d55396fd4cfa"
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
