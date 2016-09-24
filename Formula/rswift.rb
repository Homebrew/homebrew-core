class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v3.0.0",
      :revision => "ae12b4cee175cc4b571986b5bee403320ee303a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0868a3ab60747becd6d106b4cbf477b6d02e38dea961d8fe2e17a66b4b90019" => :sierra
    sha256 "766aa3106baf49c41b314051a2ee36a78b2cd550eaeac2bf6060bd235b33ea3a" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    xcodebuild "-configuration", "Release", "-scheme", "rswift", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/rswift"
  end

  test do
    system "#{bin}/rswift", "-h"
  end
end
