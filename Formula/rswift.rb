class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v3.2.0",
      :revision => "f6890959c056097f51703efde71e38aadbc65515"

  bottle do
    cellar :any_skip_relocation
    sha256 "b885b0927389818fc6cf186217eec981b8f2d18ae682333b7d708f6a0356b84f" => :sierra
    sha256 "c2049122beebd7eadaa49dbd7e14612d1e6b2a07919a2f82cde1021028cb0c61" => :el_capitan
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
