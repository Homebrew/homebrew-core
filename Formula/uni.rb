class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.0.0.tar.gz"
  sha256 "744e1d49b9cc8e336e260e0e922b28bb60f8fdaf347e656e964b5f4353c5162a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4441cc2d95b43746b9e39646b14417387d439253d5313d291ddf52002650c837" => :big_sur
    sha256 "51fa81cb09e70f107e350cbf9be7ba37fd614610da26986ed30a31662475cabc" => :arm64_big_sur
    sha256 "d6a995e94c8bc6f9b74a1eb370b5aa348a7377e9170453820400da83641cef66" => :catalina
    sha256 "1a2f04a3dd21f6d2c2ea16d3683f936e1d8310dd4b2d503aa8a60d67b6f24367" => :mojave
    sha256 "e4b8e98523d14eb9cba3991946deb0cea86c09acfb65d175c04d4233ec32eceb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
