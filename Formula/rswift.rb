class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v3.2.0",
      :revision => "f6890959c056097f51703efde71e38aadbc65515"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb79dd537fac7bee65b0b35535039ee51ded870f3b8215b4413ac1b93ef177b" => :sierra
    sha256 "c0066d6da6aa38d7ad3d8e9d69185e2b0c38bc031f7eb05f7ab3690c4df2e4fe" => :el_capitan
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
