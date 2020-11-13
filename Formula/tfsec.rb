class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.4.tar.gz"
  sha256 "dab0bbb233c7267467769fc7823affee7aae4b7872c4e2e5c3ea50faa16e02c3"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c697ff0cb8c3a566a63f0d53dcbdc5523b64cb9825ef16a8366c113c62fbed73" => :catalina
    sha256 "a43dfa5a3be0a0a58b628b44d0b5631b694153b86117cca37f491da8f7bb0318" => :mojave
    sha256 "3ecc8fc77bdb1d5544689ee15684deceab6ed52348d5212e1972f759797a2fcf" => :high_sierra
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
