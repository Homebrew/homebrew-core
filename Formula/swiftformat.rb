class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.2.tar.gz"
  sha256 "179183919dbde1f6bdb46f7799641ef0fefc29aa9ab31e52d7efb6ffe01f72ac"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3f3cdef3b5ac7cfe198294c03d1724edab9688d2d3fe9010e757d357ff7ee20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a74cb3b4628ad3c79cfe2c2d8abf92acdb61295b176352647fe4c56196773cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f8d5b63f8032f8f0cb72408ea1f2300dee0bacfb278f756ce9abc9bf3eb4bc"
    sha256 cellar: :any_skip_relocation, ventura:        "acd26d88130e0f88bd54d447ba2ec59a976d77de79686c15c12febe0715ccaba"
    sha256 cellar: :any_skip_relocation, monterey:       "1e58e58fe2f367d2f4c2be24d8cd13547bcedddc9c90ad41a2ae874cb54d8c1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fc26abebf95833fc3738a5aff0b3fcee316265db09e4bddbd1a81aea8ffc388"
    sha256                               x86_64_linux:   "b88b6dd86bc25e8f70e36d7851589965dd03e2644a79bfa6d3689ee726958968"
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
