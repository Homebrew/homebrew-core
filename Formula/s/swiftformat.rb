class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.54.6.tar.gz"
  sha256 "6149936f669e672705fd0be87759548b57ed28da32c13d054a285dd08fc56ce3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda0a46091e8c4a1a913e08e29a92159ed747d83403508e0b5408e88e68cdf0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c937e3425e9b44a73eb5ae4a83604b4476f901866014c01c1ebd3f3a8d9c198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d68be9490bce8cb196933f1f421f791b0b9758a759956edfaf166f88dfca78e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "784d61fca33bdbbdf96f8f23db2a0ea849ef62cb251eedfe83863869db84359b"
    sha256 cellar: :any_skip_relocation, ventura:       "7845bd9bf8f0f94980f38d0ac322a5ee41bde07d18ec0c93a343c4aa7d2606fe"
    sha256                               x86_64_linux:  "14756d1f83aedf183be980541393c3e4d9cfa47dee3dbfdb665a3461f5045e13"
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
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
