class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.32.0",
  revision: "1721b1e409a65000d1bcaa82400f4bb2c5027728"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f194e0c4cd520dc13c2ea2b622ba3e005dd32606b34ebb64ffc0de32566d226"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8400874432bf2363cf66a350d823b003d8168e0619768fe762cc5a2c3b5dddb"
    sha256 cellar: :any_skip_relocation, catalina:      "b18ff9fd260e6f234d7e1bfe16baef4ef64a6987a8b04831afc13f83a7bcfcd6"
    sha256 cellar: :any_skip_relocation, mojave:        "cf22563c79eb2e6bd479124ba520b40dac75f93ce97e3128e7fd16629f450c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f53fdfb2e42fe89d580f3c137c0a3cf610240ad658866c41c2ed8778b415d59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: failed to validate account: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
