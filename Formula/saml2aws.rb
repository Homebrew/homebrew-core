class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.6",
      revision: "a0995ca5d5e294aef436b85dbb792fa6dddf42ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "114c4ff56210f15c78ced161cd1795e4a0d177e472e392571f2c5f7804e41bbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a6ef2e19b23ebef47fe01f7d83cb5ef586b1567a5832063ff1ea980b9624a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8566bfa8c1811c7aa1f974312c4ccdfd2c5c6d2b0b886055d551fb7d47c1821"
    sha256 cellar: :any_skip_relocation, ventura:        "9869c43a1ff1f1a370d4d1a11a0bdee587dc90a4264e06522f213f6e7caa3271"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4e42d5fc57d837b3411de50f1dc527a794e1eb712b66da634c34ae18bbf628"
    sha256 cellar: :any_skip_relocation, big_sur:        "adbecb7c304986eafd8860731100f2ec7941bb1c0028772a9e9bedb8524d8bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8692936e156b0da403b21c02862854f6ffb469f09fc5b674331a5a77badba7d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
