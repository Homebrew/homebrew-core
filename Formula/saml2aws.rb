class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.36.0",
  revision: "6957a7412352d3ce930a99417d0640f38525811f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae2cbe79a47d330536caab6ab21f6cba706fee72a7eef912694156edb90e9927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de9d118be4a5b637b600fecc80e13cb8d7b11461125269c6af938988e620001e"
    sha256 cellar: :any_skip_relocation, monterey:       "254feb9ad98a81845b0f6713a8277c456de7308d6fb37c9f517c4cee8d7b2d68"
    sha256 cellar: :any_skip_relocation, big_sur:        "a35a6ed158042174b402ffa2b83e6caf5af61591090af50caa472db820c1e0be"
    sha256 cellar: :any_skip_relocation, catalina:       "51ff3e17e8d81e36f7cace70ae1af3197ca7dadce1779fe8f9be361cd6ef9df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3040a0cf15258d1f5f0c2647d070a481a30adb588c0505a7f051440deb674c8e"
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
