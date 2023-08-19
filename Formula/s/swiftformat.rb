class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.52.1.tar.gz"
  sha256 "badebec6a37c251ebbe4100a91f8223777326952b52e07574b3c486f8726bbcf"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9b5c3fe05ec730464127dcc52f3b04c7af2a7ee78a2b023ea781ce630d136e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d2b0ff8ffa05879b8916c113dad7bbc985ea7ca07c23b85d9705e5279d55ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "490f4ccca8c5dd5dc9fdbb6d261b172821b7af60cf005596f04b54e2a106b34e"
    sha256 cellar: :any_skip_relocation, ventura:        "276c3a2f7a0ab7a8e35c77e79493ab0f6df8c01425f91787ac50464f4d229c50"
    sha256 cellar: :any_skip_relocation, monterey:       "b2310e19f61c017738189a06aa68c5b99654190d2b35aab71020235de90304c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ece129b6c2229b5ac241d23202ca676be0b16c8eab83d7b0be9d84c6122920"
    sha256                               x86_64_linux:   "461c3a44ad7a610ac2787b0c9db39602c2a4b35392f4e4d0aad004df013eb33e"
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
