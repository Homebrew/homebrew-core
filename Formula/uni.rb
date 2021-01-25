class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.0.0.tar.gz"
  sha256 "744e1d49b9cc8e336e260e0e922b28bb60f8fdaf347e656e964b5f4353c5162a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "37fe7b02e6737bec8b2200c31e336a79b7af54cfdb22ee82ee1465e429276572" => :big_sur
    sha256 "6edc8fe86733254e8ff4ee7176f2b97c47196206da7b714989f9c324d596ad08" => :arm64_big_sur
    sha256 "9a4a7180d2b989dcd2514e87b8a1153de5d8b284a07b191d6197fce9784b0ea3" => :catalina
    sha256 "b06d8669efefddbe70b7b07634f4db98a3283234284fbcc1e8326ec6c18ee9fe" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
