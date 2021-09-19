class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.2.tar.gz"
  sha256 "94cc5f195fac8617873f30616d65eba4b44b2ce4c58d7b6a5f8e2bbceef569f4"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfea74c461af8105ddeef40028571ae94c0d400314c23ce2c7b688a53d4bbc68"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2360f47e129d9f7e5a21f8080b4b3a4026f186372a5075772f50335fcc2631e"
    sha256 cellar: :any_skip_relocation, catalina:      "cf74861e3fafb6015dbc4762d2bc29fd638f76f2e0c3bcf20279221998407e41"
    sha256 cellar: :any_skip_relocation, mojave:        "2e7b44917e4e21e938de91a8a8ae5b3783e56ebe075eb11be51569e9a0ed4aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e10ad40bdbb6280f3303f43439791ed3f76213111d17441f673374819bc4994"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
