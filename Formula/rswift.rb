class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v4.0.0",
      :revision => "0306ec185ad0f7753e9ea44fefdbf268d9e62184"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ee4a269de5d86096012f0e0b1c06e985193ba99ce18ccd2a69542d41e7f7aef" => :sierra
    sha256 "79999cf741147dc10697f8354a14a43d060d0ac6ba352e7887b685ac8ca90c79" => :el_capitan
  end

  depends_on :xcode => "9.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
