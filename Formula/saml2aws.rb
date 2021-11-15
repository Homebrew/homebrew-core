class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.33.0",
  revision: "8c1b6fe0462b578126a8e95caad2cb35b852f60f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb8e36c654c934cfee75fc419cba8fbfe0702effc3cc22eac638483ced75e77a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6168c7fe310573af1e0c0c70a3c4b3e0ecea07b253f6c9f6ba283088c61b21e"
    sha256 cellar: :any_skip_relocation, monterey:       "52c128f250038ac148c3df2dc7ac4882c0d9b35af606735c57513a72f61787f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d584f6c62d8d2d0e7487bb5a7d0701df645f3aeb88b64a144f8920ef476f84d8"
    sha256 cellar: :any_skip_relocation, catalina:       "e245ff6fcec25833b13a302fca07495af9a15e4fe0d64281890bbce8b3ec0d22"
    sha256 cellar: :any_skip_relocation, mojave:         "b3c970247b2755e84b9039cf53ed15bc6fbb48a6918c508df10dbdcbdfcef3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a133ebc8d420a261faa7d54c8a7dfc445d62085bcc9a5a61df46b6e2f63bcaba"
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
