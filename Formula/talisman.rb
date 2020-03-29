class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman",
      :using    => :git,
      :tag      => "v1.2.0",
      :revision => "6e6178be65665ce84b9e2c9b100c59846e75f494"

  bottle do
    cellar :any_skip_relocation
    sha256 "701e360c802243d9bdbd15546b02c33ea6fb452a6febde5ce58592e5441f085b" => :catalina
    sha256 "fd9a61d296fc9170231f9392af0c9ffe5b7ef799ab84b65664ea15e13a77adfa" => :mojave
    sha256 "708f657afddb95aef4d707ec18735e6d07b1abf2202a6fcaceafdfeca30c6436" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    system "./build"
    bin.install "./talisman_darwin_amd64" => "talisman"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
