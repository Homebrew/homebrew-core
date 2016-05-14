class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.10.0", :revision => "fbd2bcd0edc264e04d02f87b0d0f98add754ac88"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "67e1fea2fd98c1196f5ef5262ada7b06cd4fd6479c4112ff96155e70aec7218f" => :el_capitan
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
