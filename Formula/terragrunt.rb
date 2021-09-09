class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.10.tar.gz"
  sha256 "efa57adb475ac69ab19cc24a22d380b2d2700bfb6361d8a33a712cc2f191830b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e6cf2bf18a05acf4df6e6748d35a82e7c085918638c4abc9ad311901f05c21d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d54915f105fc5376214f7025a084065144851510bb15a7becc4d73661d805b45"
    sha256 cellar: :any_skip_relocation, catalina:      "08b16bc2e39870d9ad122bd9e33632c3105d84d77bc2ad326b471ef9b5e29ad7"
    sha256 cellar: :any_skip_relocation, mojave:        "f6351d2f916bc3a3062664da55e50bc52b12b1d53ccd19745e44106e3f7f1a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6953b9795123adf5635dca9716b35fc687d08bccffb694f19cfd284508b65295"
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
