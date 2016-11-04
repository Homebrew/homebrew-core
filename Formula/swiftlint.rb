class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      :tag => "0.13.0",
      :revision => "2246bb924605c3a47b9209d77eabfca4945b856c"
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
