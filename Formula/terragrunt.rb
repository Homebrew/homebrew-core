class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.0.tar.gz"
  sha256 "2c51e36899becae3545c5d41dc96f66a6b0f7c29763c164cc9dfb7238d496f1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "249ad68726fdfc0059f725ac90eb148809ec7ec9ae95ed5ccbeab005f7555b59"
    sha256 cellar: :any_skip_relocation, catalina: "534354f2ab8f06323b7b447681227795b8318f0be7286241a24b58db38577a6d"
    sha256 cellar: :any_skip_relocation, mojave: "887527a4a254f1fb47dd2951c9ad6bc9826b9f6e3e4686ad5ffaa86361e269f7"
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
