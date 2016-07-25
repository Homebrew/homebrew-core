class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
    :tag => "v2.3.0",
    :revision => "d49c00dfe93066d5ab61ab7ae92965857c98d60f"

  bottle do
    cellar :any_skip_relocation
    sha256 "744d149e4b56e1678f81c1dd566a5bd6dbe98fe38f8b38e4e617779215365f4d" => :el_capitan
    sha256 "77bfe21d31b824a7d61ab66f65a9678e69dc22a1cd590156a019d3f313491a8d" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    xcodebuild "-configuration", "Release", "-scheme", "rswift", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/rswift"
  end

  test do
    system "#{bin}/rswift", "-h"
  end
end
