class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.14.tar.gz"
  sha256 "3a890e8582d78088db43cfe6bc84a98fd3176b4dacdd3ee10d04b044e96d91c3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca3ab9db1f528cd75201a3cbe8a165c92181fe4353a0aae3002e762992606e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c9ca8d9f5d303a9e4e4e4359022075abb82d835cecab2f374960d80be6f366e"
    sha256 cellar: :any_skip_relocation, monterey:       "6686aa8139c4c0f70c1b6b491ace161e0d767ae3a0d9fb27aa9379968423c93e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d46d7bdd32e2743e54db27aa757c75f454626ddce633fed24c2981c2227617c"
    sha256 cellar: :any_skip_relocation, catalina:       "309a419a4345fd1ef7ad75dddbe0995b5dced750b2621ca3aaa1ba49adaddaed"
    sha256                               x86_64_linux:   "af6b21401a7697c6f58d9eb84d14f896e017168193f585e3e571a6eddb77fe7b"
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
