class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.24.2.tar.gz"
  sha256 "769a0f6d9fb2446c02587b50a0b85be618e077f938cc74adf0500ddb4861285b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2be4761a043b4892cc4a08c0e199f3fa81f50f2312b2f8dd2e1b1d6e824fba3a" => :catalina
    sha256 "f5b7ffb704f97b4425eb09ab12b5493e0be8736a4ffc12632eab3e34df9dfdb2" => :mojave
    sha256 "1b60cbfbfc3a16f505c82ce5f1ddea14ea04c1e41433d0d0cb7be543a95070a9" => :high_sierra
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
