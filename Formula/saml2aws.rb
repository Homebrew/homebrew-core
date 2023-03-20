class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.4",
      revision: "8e2688a6fbbf6331eb58246a62dc42060b6229f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae5a87c007a009283c4a0306b8dc491f0cfb4c02ba36b9b00aefae83826b5d5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "279777218a7936aeec206c0424ed7dc33b018a0c98df4b7802c38773d34c98f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "facbc845229986c8f7ee34efebb9d395c7bb8d2709d5c6405c10ba788b857be9"
    sha256 cellar: :any_skip_relocation, ventura:        "008c8ff130709f5f33a4f46735168a9fcb13b248483d84f924d8859b02f42eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "be69292275dd2f177143e17e06656845fe20b693bff879e76ad7f8999cd2b97c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e4a28cdb7e5ee63cae8d7acca986094133e96a9acf20739502c2cf3db5c2c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8673b953a52afb1b892b51e07377b35c28c1ea6de8d7efdc42c92f5ecc498cb"
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
