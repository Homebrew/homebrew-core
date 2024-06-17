class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.54.0.tar.gz"
  sha256 "2a67b718c3ee0f8d8073bcdc8aab757abc0fe8fc97a81ae1151c3699ae72a4a1"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe9f74ac9328f6e71a44ac6a35b53e765526d020f47ae7b1dbdb3188f97b00cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8afeb9cd7e17d38ba45db65aa81a33e65357e51cfe5447d6bb7faea8bb74f5c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8f3d798d94b3c9a460c5df1cf1a14a1ca041381f139113fe9229e03007a163"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ea8d82129474556a98ce1da2e63986a24a670eb3682283f9e4d435295851a15"
    sha256 cellar: :any_skip_relocation, ventura:        "58a57921b9055a6d7728f5f19ca95a3f3cab307cddf0ddeac7cf1ca588226039"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a6ff5318a6774f153cf54e26b8b4ad63be14d6c1aa2663379285df553bb58d"
    sha256                               x86_64_linux:   "b93ea4171c93acf7baa5c9e3eeaa6683563f6ecb9dde01ea2079500239b84eb4"
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
