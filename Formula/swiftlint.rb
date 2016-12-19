class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.14.0",
      :revision => "7e7576e9f34bf170ad8f6fd043c3031e9ebbecd4"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "cf9d794e66aff772cc2a61cbb5bfe7cf4b851cb1109f7714c572bf4a9c760f8f" => :sierra
    sha256 "78d41e8e7bf1c662c0b8546ae171b358b0693344ce912f7837a5711d106e584f" => :el_capitan
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
