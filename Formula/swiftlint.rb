class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.11.2",
      :revision => "0026f301b6995660e8dd20305eb92435e620f092"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "5fa285821370d860ad85b3b137d56e586d71552c2dcabb66ff187f08f01d02d7" => :el_capitan
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
