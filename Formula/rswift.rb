class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
      :tag => "v4.0.0",
      :revision => "0306ec185ad0f7753e9ea44fefdbf268d9e62184"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb5d11f44ba595f13aa00cfe6439d20e39c84ae78f84a38117cce81150393a30" => :high_sierra
    sha256 "8638bcbaa77fd1861c6d1978bed6d2ff7cbc2bdc7ae6d25df9471428d53b784d" => :sierra
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
