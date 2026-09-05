class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.65.1",
      revision: "6aba03e3d8302b33f106e0f922210f35ca4b52cf"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6b8e9b80ac560e006af06124c41682ee00eb4db47b4c5500e5e153c86d0c09e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "379cd81efd42ca0b6b7995477f4f4e096b560ca1a4dfa4f68f8246c6446ba3ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758d2d2157b9f40b3dd93042fcb51963d53dcc3835d39538356a5d0bf708ec6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6170b6899ed29ca518e2a911667e0f197344931f941ad6a163bd9704a9649085"
    sha256 cellar: :any,                 arm64_linux:   "02e5dd965a9a891ed798faa5784861aa41a6fb7a128b2960897d8dfc6d0e0b00"
    sha256 cellar: :any,                 x86_64_linux:  "11453dbb5a364c41b412301d2afd63adcf9554c160d19dc89f38440cd1a5f95a"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on macos: :ventura
  end

  # downloads dependencies
  allow_network_access! :build

  def install
    system "swift", "build", "--product", "swiftlint", *std_swift_args
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
