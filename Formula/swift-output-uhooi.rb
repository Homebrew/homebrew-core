class SwiftOutputUhooi < Formula
  desc "Uhooi speak the phrase"
  homepage "https://github.com/uhooi/swift-output-uhooi"
  url "https://github.com/uhooi/swift-output-uhooi.git",
    tag:      "0.1.0",
    revision: "c64a25feac6b4ae87e510a2f19eeaad457659ac9"
  license "MIT"
  head "https://github.com/uhooi/swift-output-uhooi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d38329705b9c17175c80a784315e2a310b8e5c914bc8f3aff6b7ac41b4fac7f7"
  end

  depends_on xcode: ["12.5.1", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/uhooi"
  end

  test do
    assert_match \
      "1: ┌|▼▼|┘<I'm uhooi.\n" \
      "2: ┌|▼▼|┘<I'm uhooi.",
      shell_output("#{bin}/uhooi --include-counter -c 2 \"I'm uhooi.\"").chomp
    assert_match version.to_s, shell_output("#{bin}/uhooi --version").chomp
  end
end
