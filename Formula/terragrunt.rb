class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.1.tar.gz"
  sha256 "d72f24dd94d3ec7112766c0b5defb67863f52d9bb41bd06b707312dcfb11a246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "e02dbb8aaa523852537f89ce977f6c18b9335dbae511de9ecfb15090eb7e4c2c"
    sha256 cellar: :any_skip_relocation, catalina: "368e4396646cbb8ea0d99bf76dbcaf0134d8e081b0f8aeffa09e31fcfc0c410b"
    sha256 cellar: :any_skip_relocation, mojave: "eb597b603877e1a8eb2729d0ce7798dd2014cf47cb3c57ac250fcaa235bab510"
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
