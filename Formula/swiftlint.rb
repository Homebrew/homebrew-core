class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.13.1",
      :revision => "51466bf7e971dfeb705b022263e7cd1879ca5d0e"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "fac2a3a19c0256519f51d35d9c4eb23002c71866b20c0b3690da8fc852ff3e26" => :sierra
    sha256 "e1d92842e615cee60385cb9685e744aa81bbb4731ece07d5a5bf1b4e8185e85c" => :el_capitan
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
