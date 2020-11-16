class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.6.tar.gz"
  sha256 "2ee150aed3d0a2e171a56d5b194d2e4746259e644cf1ca53d43da616157d20dc"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "008c7e111d891dabdae4f3e1dfa1ca2ca0a315f7e4d1e8c27a01f66f30755091" => :big_sur
    sha256 "4ddc5fe1411abc1810c196c0204eec35478014cb3910ae5f65d0afd4b0600dff" => :catalina
    sha256 "fb8796f85ea6a23aa97049b594dfc6e1eae47c679c11338360a5cb9aa04e9ad5" => :mojave
    sha256 "502f9522b57d904ec7c780de9bdba74a7a733ed57de13e549dfc596750f3a2e7" => :high_sierra
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
