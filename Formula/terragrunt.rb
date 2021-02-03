class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.1.tar.gz"
  sha256 "d72f24dd94d3ec7112766c0b5defb67863f52d9bb41bd06b707312dcfb11a246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c06a962e8755b4127f96b106b5d45fb79df8342a3e21580a5856ae51d65d4137"
    sha256 cellar: :any_skip_relocation, catalina: "4a43966500b7179a14c2366151532f43039148a94270293122e8aa3279fc1851"
    sha256 cellar: :any_skip_relocation, mojave:   "0262c9545f5b5dde5d6a6b0056e900f597b9616b8c2dc64bda5bf317ec5e8ee3"
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
