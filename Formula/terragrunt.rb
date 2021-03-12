class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.10.tar.gz"
  sha256 "1c47899b138b7b51882d665fec0d4178bf1813b42d1150041949fea04da1a078"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fad7a630825c11077bdcece577f70aa1091856899798595c988c86e3980b1a48"
    sha256 cellar: :any_skip_relocation, big_sur:       "1541e79a9d8a39626c955f7ba887ae3fdddcb44d053db938c56044b84c410eb3"
    sha256 cellar: :any_skip_relocation, catalina:      "797d01c12fc0f548fe12391bd8ec152ea790d021078eeb29aea3cb963ea8e7cf"
    sha256 cellar: :any_skip_relocation, mojave:        "3201fcc12ff5a2261f752c07e61539ce7507a5cee0fd52bb2f8c9eb53fdc673f"
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
