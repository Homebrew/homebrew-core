class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.13.1",
      :revision => "51466bf7e971dfeb705b022263e7cd1879ca5d0e"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "1ab04b23205c299a51afc9e1b9c7c2d8a1d5701e6eb47b0dd0372baae79dd122" => :sierra
    sha256 "37f89e394c688c56362f601919bea6ee5c451252946010f2e26e3bcda2f71f31" => :el_capitan
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
