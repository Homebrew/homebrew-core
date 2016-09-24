class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.12.0",
      :revision => "0c605fb98dc94c913a1f716e1a8bcaa357f477c5"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "b174799dda134addcae206c520f3242ce3733686b61669c76305064e51738614" => :el_capitan
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
