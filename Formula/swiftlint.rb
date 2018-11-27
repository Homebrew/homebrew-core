class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag      => "0.29.0",
      :revision => "8fc75e393b91e59699b4e93a068e7e0ca05bab54"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe31821c814fd92e8e485b83c33d262d5d91213c7a3eea266370cc8b2e6b9d8" => :mojave
    sha256 "07846adbd1993d741fa26a08ce8bf6867e0ba2e1017915a78a24c5a8e09da171" => :high_sierra
    sha256 "7453d072b672c2e17f5bd1e4e644540373931c34d4b9700e92e58c4df935dc10" => :sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: Files should have a single trailing newline. (trailing_newline)",
                 shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
                 shell_output("#{bin}/swiftlint version").chomp
  end
end
