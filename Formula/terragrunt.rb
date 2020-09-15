class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.24.3.tar.gz"
  sha256 "1d58c0a8cb19246022bf363c500541ae5c7f17bb2a520b116eb620cee207370f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "964ea3954cbe97cc5752034b74042c562ee4c582fbe284f99b3fdd89d5aa24e2" => :catalina
    sha256 "5bd02cb9c53a16ae95bfc699a51fc95368f991343dc4da5b1e47e16c2e785969" => :mojave
    sha256 "6989cfaebef3b3bcaaab92537f61dfa76a95e335754de56eb7b67bc2c0bdde18" => :high_sierra
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
