class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.8.tar.gz"
  sha256 "b9fc4b7e6842efbc85743bd323bc5dd35b43fb6dd64050d0d00459053de628a6"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b8b80a112208df68929295a6fa5733437e701527fb305b0ff0a41d7d933e14bf" => :big_sur
    sha256 "706d8eb0b6b8b7664c1baf00b47620c3caf3802487beef690e9d8dfc76603571" => :catalina
    sha256 "422927f815ccf34c469c171e4d1c5c2b2405bfd5dee2d39f108c6fca6eeff0ba" => :mojave
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
