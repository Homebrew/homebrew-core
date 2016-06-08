class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.11.0",
      :revision => "3ec8fee271fc509d17989964c595524a8ba04599"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "67e1fea2fd98c1196f5ef5262ada7b06cd4fd6479c4112ff96155e70aec7218f" => :el_capitan
  end

  depends_on :xcode => "7.3"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
