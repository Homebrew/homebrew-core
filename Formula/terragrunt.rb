class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.9.tar.gz"
  sha256 "4d560fb14945ca90a7b1b17adbe841fd5a1bfbac8f841f92254d0ca7ec9b0e6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36fd568fc62a8d4327ff849d423de66b2296f61985fdd6d8c35b32c0de05b8d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bea35872f30644cc1e015d890b319b70a1918b91be2c383d42836f3e83dec905"
    sha256 cellar: :any_skip_relocation, catalina:      "bd0a4d4e23ba922104cd889de028724e89df914ae47b1b71199a1f4fbf75c840"
    sha256 cellar: :any_skip_relocation, mojave:        "ceade3d31c45693b76e3394952eeea9f46a17d79053d25780c6af6c730fa43be"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
