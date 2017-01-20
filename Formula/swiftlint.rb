class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.16.1",
      :revision => "16ca04905c769657c22e3a02435992b41ddfdc52"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "fed403cd59e941cfa1d044db16061c8b637869c74a691880bcf99c9d733c66cd" => :sierra
    sha256 "75167ccd507a0e6e5fef1a942bcae6caeb6926678f82844b15f550be08b32a4e" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
