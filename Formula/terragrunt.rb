class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.14.tar.gz"
  sha256 "c88eabfa42e79cf0eb9d1b6b88393cbc58f5d5ed5fc3409bd648bd2dac27d181"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07d8c78bad0816b8ab20c27f8feed5d58d7bdc1fc598b631b4e7a84670ffae73"
    sha256 cellar: :any_skip_relocation, big_sur:       "187009154957fb5ca18698721d393d24260c65361989363759093eba2f119ad3"
    sha256 cellar: :any_skip_relocation, catalina:      "adbf40e4e7e1b1f8a33eb42e1d7ca82a73fd119e0866adb8ab8445a500eb008b"
    sha256 cellar: :any_skip_relocation, mojave:        "6aeb82aaf0f588fc143a09a7f5cc2337495be5c9eb3748dd1f73e541eaea5ce4"
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
