class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.15.tar.gz"
  sha256 "c5d8f24100004467f8f66539fed6b53b726b17b486b57bbff3ad098bb4579222"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0d2f1b0faaa1061d1e41e42341d25e4d631ae0f8f97b4e934b6aa567627566f3" => :big_sur
    sha256 "e5b118cc584d28c05a04a8b87dc61b6b944d1847bf6fcfe5ba86b9a7644da193" => :arm64_big_sur
    sha256 "738e2cdfb180e27f1563662a9215afa0d10f52d7dcfb34cf9ee14a3806776c0c" => :catalina
    sha256 "10c97c918d00ae760f8e645fd9e3fc005f0f6e1487ca556049453c9bd27f6d39" => :mojave
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
