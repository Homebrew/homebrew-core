class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.2.2/rswift-v5.2.2-source.tar.gz"
  sha256 "b27c51e9c69adcc61ed2f8a476fa5f2d97be5996d4f1e59a0e1b754a58980e26"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
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
