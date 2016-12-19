class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.14.0",
      :revision => "7e7576e9f34bf170ad8f6fd043c3031e9ebbecd4"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "035ce56cb74d7affc699acb46e442bfa8444d2822b6ed5e646ebfd3148185a15" => :sierra
    sha256 "0352beb89305e2b9b71e68579bed8fb317271d7673a8ab6504d906e12d3d3071" => :el_capitan
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
