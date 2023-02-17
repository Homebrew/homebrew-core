class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.3",
      revision: "a2d27433fd81b94c800a10ec934b1bfefbc80345"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ae929d0682adf83384414fdaff0e6a38a7959118eaba71927e3eeef3d91aeb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4807c36fadf928ea4af8920f4d2644e7ec66d78e796d58b1eeb9a3e75411215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f69568ec61d97f67eefa26196e0bfc8bf718066c52d4af0fc9f4cd1b883fcaea"
    sha256 cellar: :any_skip_relocation, ventura:        "09b384b6f00739b4f7ae4fdb80f74cbc38ad4cb007cc4f1d3063f8789502e5d8"
    sha256 cellar: :any_skip_relocation, monterey:       "150e88f21a49c396e21137b34f81bb6bf8c08e240bb515013d042670ee34cb0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "477dd37003139b0562f1c1c4bee09b836701b2c55a80ddc40c0fb76f0551715b"
    sha256 cellar: :any_skip_relocation, catalina:       "4c226e78942b19221caaa69253e363c540d6d1e0c57890465cde638c52d9be61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2364bea7522630f12e6ecf896a9449ab0392e3b26270c049fc17036c357dd1bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
