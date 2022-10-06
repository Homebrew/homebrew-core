class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.1.tar.gz"
  sha256 "1baec6a1478cf36aa8a0d66d263d5bf8cf6de61f5587d2aee59bd45e272810fb"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4999448b30115ba9c9074dc1f8094fd02a105225b8f0aece2d16c2833b7c5607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd415502652d1f4232dd9cd218ceeb3d725baf8bf5748f9446804425ce1fa612"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb77dea607e468e72d9f63a075f8ffb79d7d87c89533cb71912e5a2413aaee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "255b3c23080c8c9b17dde64673c194a0e3262d678b44d2cabe42326e922b18e1"
    sha256 cellar: :any_skip_relocation, catalina:       "c9a47c0c09cdfb9e6cc70230bba8bd6dd0384f2c4f12d0379836df042d746c04"
    sha256                               x86_64_linux:   "65b91e5b9f878e0538982e9e9bde0a5b1080eb60ec70c0b9e90b5ce359bb978c"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
