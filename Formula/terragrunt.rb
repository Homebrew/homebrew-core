class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.27.1.tar.gz"
  sha256 "5cc13d6556b9206335be97a5e8f163c85e2097a44b352c284efb369ea6c0e446"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "74e29b1d404c975c8ccaabe9279a3e411541394dafe7748d99cf249c7804cfe2" => :big_sur
    sha256 "02fccf8e475ee846f2a243f401528a739864b7c5389a41818015e4257208ccb3" => :catalina
    sha256 "f25d564b4fad246c6e3e4425070a9e6dcd7d8721387852871f4bee7be6e0148f" => :mojave
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
