class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag      => "v5.0.3",
      :revision => "e04458d0de265a2e40804fe2401ad4bc711a8b16"
  head "https://github.com/mac-cain13/R.swift.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "438e662d49b9624d95baff913a2213ebca2b34aaa3380bbf194b06309f0a0cf4" => :mojave
    sha256 "5c6d4b4d92f96d77a6bb5d816a9661901f3f61be696ea3bfc3aff7507b318c34" => :high_sierra
  end

  depends_on :xcode => "10.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
