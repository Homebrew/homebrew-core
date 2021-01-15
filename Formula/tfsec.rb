class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.13.tar.gz"
  sha256 "a5791f2d94c1bd64a4c37f913d9b9f7e96a4217b8a1537283df7f9775c255401"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d52977c0e1633e79c618cdd626b83cd3c70518262ed1b914bb4de9b214890a67" => :big_sur
    sha256 "f376ce4fc3e346b99b6249211f7322fab92860482184201ceeeb104dbeb31d10" => :arm64_big_sur
    sha256 "89beeb7ae5b362f7f77cd856f7547f4fa8379552ca61ea7f53c5a06ef50a30dc" => :catalina
    sha256 "5d84efcea25d2a08639e25d26ef9f7f488d8f194f597335ef3c2e6957ced04a2" => :mojave
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
