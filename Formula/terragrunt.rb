class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.6.tar.gz"
  sha256 "80cd470c2078b368fb707348794f1afe20558a0c31a1b7685d966e904e2029b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67ebaa5cc5ce0eaaea3487d6165fc030365a4a4690b43e9cd14cede4f00be2c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "93cb49d8e5efa8508892f6fa6c8c694b4d2b212ec32c98f61143c77eed95b840"
    sha256 cellar: :any_skip_relocation, catalina:      "3282375bc630f62b0ff74cd7fd881d9cf7366ed8fbd334f7391a7305ef3fb318"
    sha256 cellar: :any_skip_relocation, mojave:        "28f518964cdb0b90c93edbca407ef2108cf1277de65c7e5213a710d81168c7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae3525c4e9b5dbfcbcf6eea20ff99e53a5729ba9f7a9330e83925e56eaa255d"
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
