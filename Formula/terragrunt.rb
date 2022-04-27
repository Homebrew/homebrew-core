class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.36.8.tar.gz"
  sha256 "86f7da3156e6ff9bcfc14832218e648f2c202fb3075f6d661903f3802c6e9331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9f70b4cf830872451898f6e24bdeb67751679350ebe92bf8a6013bbea27078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "549fd3a8e5025417c898eb810cc60f06240d80a14689448a19c00939475b7f88"
    sha256 cellar: :any_skip_relocation, monterey:       "ebcf33b95bcf8cb30bcd09ba9b2da8b8f7e4ac5071afa4880d0820c411eeb3d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "561cedf0c7a63fa45fa34a079d835252ccca91d35c2e0baedf36c651d733e8dd"
    sha256 cellar: :any_skip_relocation, catalina:       "87ce0211b8f22bb73828aba80d0969902d0ffa89f2086e9990005c0ca7665561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd36eef41aa0f4c89993317473feb7ceab1a54201cc943907675d29f5119c6c8"
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
