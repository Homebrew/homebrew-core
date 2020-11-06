class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.2.tar.gz"
  sha256 "775baa3e859b30c586660b914d9b30c0ea00f7fbb44506f0ebe723f5ebee771c"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ec4e355a7d75b6217f68ac3114e7439c3fce51656cb4e2ae8796f3c6fcec5972" => :catalina
    sha256 "5c6f01d57ab00e1782007417c7544df0812ba8d37151711198fc38fb93ce5209" => :mojave
    sha256 "c492b294c8b9a8ee802b48b2277f9b5db535fa3a156496722621a4669ac004cf" => :high_sierra
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
