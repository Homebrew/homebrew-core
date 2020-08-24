class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.34.tar.gz"
  sha256 "72467616719a3b5379af91f89de5a4766bd40b1c996c4e44dafdfb9f5f25e5ee"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a682ff3818c7ba80ea54f46e9f9085e5d22f13161a37937201f60ad125cef72" => :catalina
    sha256 "6192fc023d2bc219549c8d40657f6b226ef51c4c919cfb592fcb62a2279cd701" => :mojave
    sha256 "478bb13fd0f6d51a9fd61af685f1b0eb725e515938df96ec3a83bebaa3671ea5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
