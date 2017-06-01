class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v3.3.0",
      :revision => "d341d73f6009553717d5a0e8d813c21dc9f11e31"

  bottle do
    cellar :any_skip_relocation
    sha256 "b885b0927389818fc6cf186217eec981b8f2d18ae682333b7d708f6a0356b84f" => :sierra
    sha256 "c2049122beebd7eadaa49dbd7e14612d1e6b2a07919a2f82cde1021028cb0c61" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    ENV["CC"] = which(ENV.cc)
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
