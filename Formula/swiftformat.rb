class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.17.tar.gz"
  sha256 "a08d61042905390b7ad2546f45db76f377758c402710481f19c5a0b4c1ece3b4"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8fe7d540663a5269dcb8d7e905ef59d3001cd531c00eb32dbe2045fe0a7c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908af0cb113c16ef5e9188534aa1fa32765ddc22d0017a2cd2e1e86c2bdc992a"
    sha256 cellar: :any_skip_relocation, monterey:       "c1e884440f3fb83890d0c7d3dea5af8126c014e052e93c0d20c906f7f09a06b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a4fa617ff27b49be2c6915c937c7bb2c043513f9a82da2266266513f0ce52a7"
    sha256 cellar: :any_skip_relocation, catalina:       "933be72e016c325cff8ba063adfdf14192e79de99d7b16ca92e2d3b08272e995"
    sha256                               x86_64_linux:   "82105b483bd7b0d66e5fe20becf14175b82db22519f98f3ce71e424c14850beb"
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
