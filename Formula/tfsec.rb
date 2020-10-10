class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.30.1.tar.gz"
  sha256 "95c0b856c95185315cdad4b8442b65cd8178664ed36d776813230d2fb15c43ac"
  license "MIT"

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/master/example/brew-validate.tf"
    sha256 "9267e6cac1277992ac521f417c6d552eff3c4606520f584bd8c1ea67ae0880d2"
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
