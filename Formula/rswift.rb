class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.3.0/rswift-v5.3.0-source.tar.gz"
  sha256 "2ac2f3bf1bef3bec82018ac7a74894022d3a29dfb49e38734c97cfa8f91dc7d7"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "725bc1c842394c544ae24bbcf278093627b0543d9fa2ebf7f43603a15a90367b" => :big_sur
    sha256 "1da952f52f531fcc1cb86888ce59c97547636855a4e2d23d147591ed9de0ec49" => :catalina
    sha256 "a344a394d9edece2c4737eec24ed2ed087719e0b95dfd269aae80b6b90040b44" => :mojave
  end

  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    assert_match "[R.swift] Failed to write out", shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
