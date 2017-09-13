class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v3.3.0",
      :revision => "d341d73f6009553717d5a0e8d813c21dc9f11e31"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ee4a269de5d86096012f0e0b1c06e985193ba99ce18ccd2a69542d41e7f7aef" => :sierra
    sha256 "79999cf741147dc10697f8354a14a43d060d0ac6ba352e7887b685ac8ca90c79" => :el_capitan
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
