class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.28.2",
      :revision => "4cee9376edea33bbb3c22f4fb536788058744229"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69de36cfca7bd7a753661a33217fac434b621e889ce77527cb91f34cf0de5d36" => :mojave
    sha256 "ab239a665b7546749a38ceb9f7ac1f7199efebc1a015d22f36f467fc9d0c69ea" => :high_sierra
    sha256 "fd36f14e08a2ec39fcd9ed0eca050a204ee29d58141f9fcbce555331af9138e8" => :sierra
  end

  depends_on :xcode => ["9.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
