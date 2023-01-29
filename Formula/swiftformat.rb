class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.50.8.tar.gz"
  sha256 "c4414e6318dd280ba80cd6a69d9abb44f35cca31190d46e939e7994ed69c0cfb"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5649f3bf5fc4444e7aa679248f39023c7b401acba530bb3613e508f6a6d129c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2ad10d717e89f5b48f1a11a9a91e0d48935275226ab0853cc985b12da36fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e212110bc90c4117e5cecace8d3be4de7f22927abdda110bb504348dd1afc23e"
    sha256 cellar: :any_skip_relocation, ventura:        "f74a5ad15b47ecab57b14304283030becc42763a6a9c1007ba9dc6bdbd776a83"
    sha256 cellar: :any_skip_relocation, monterey:       "c8df903080e91fa7c0db1b01227ac15ba006adfa657ed7fd144bfd943d790573"
    sha256 cellar: :any_skip_relocation, big_sur:        "16e18697e6da3cfbba63d58ac80e4a864f2cea51cebaaef3dac7a1135b404c46"
    sha256                               x86_64_linux:   "ffec3ad79f92ecc57343df0d2b36d18c22fd4f9fbd9a67c6fb58d5e97e727ef7"
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
