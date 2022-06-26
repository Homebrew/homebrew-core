class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.11.tar.gz"
  sha256 "418b0b44a85005787b1bf6ce89a0660cdc2bed22768e948f13ac268beaa910df"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c355872557efa651e7baa0a73414b4d944c8045caf5595b49be5aa487c790b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c6bcd203119f7a0f687ae57502bf93bbd9d4b05e838b8a8e3dbc76679b54c0"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d59a615cf956c6ccbdade566bcb18e1f4aeeaae8399f52e55a4bca7b014ed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dddb88b994904ae813b35a9a3d08f33bbd8b7f1bc15addce9e3d366b48257f5"
    sha256 cellar: :any_skip_relocation, catalina:       "a0e7393b2667a4fb21723f0f50de3b97c256237aa572927b103dd7467fe44624"
    sha256                               x86_64_linux:   "1d855fe86b853bf153171aa4b9b22c638ba63d42e052795a5e7713afe71f39d6"
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
