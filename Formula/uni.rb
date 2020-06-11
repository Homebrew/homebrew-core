class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v1.1.1.tar.gz"
  sha256 "d29fdd8f34f726e6752e87f554d8ea73e324b7729afaf4bd52fcae04c7638757"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c318047d1d8348208c60f960564c5f72b46924ec224788ee046d706ccebee6c" => :catalina
    sha256 "cb7ef66cfcc75de8b90003dbd598bd456b7384c21f587977a48d70fbb0c1073b" => :mojave
    sha256 "f343d429d9ab048abc7bda0de0acca051d25657276956436d9169fafbdbf78bb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
