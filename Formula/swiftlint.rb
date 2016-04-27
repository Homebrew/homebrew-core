class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.10.0", :revision => "fbd2bcd0edc264e04d02f87b0d0f98add754ac88"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "3efa117e8506cec1eee8dacaccf6bc86e009d189502a07fb265064390cb7af69" => :el_capitan
    sha256 "dc70240351452d4a9fe8b46030b7d4e4db93c005445a5b712956515fafa5ec88" => :yosemite
  end

  depends_on :xcode => ["7.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
