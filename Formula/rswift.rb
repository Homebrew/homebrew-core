class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"

  head "https://github.com/mac-cain13/R.swift.git"

  stable do
    url "https://github.com/mac-cain13/R.swift.git",
        :tag => "v4.0.0",
        :revision => "0306ec185ad0f7753e9ea44fefdbf268d9e62184"
    depends_on :xcode => "9.0"
    patch do
      url "https://github.com/mac-cain13/R.swift/commit/082adb3a4fb3835507e61de15dabd2e9e1b547fb.diff?full_index=1"
      sha256 "6ebaeaeb0ad29ad94f1919683cc064455837a9d0e7b2cad83bc9011d60e6cf2f"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bb5d11f44ba595f13aa00cfe6439d20e39c84ae78f84a38117cce81150393a30" => :high_sierra
    sha256 "8638bcbaa77fd1861c6d1978bed6d2ff7cbc2bdc7ae6d25df9471428d53b784d" => :sierra
  end

  devel do
    url "https://github.com/mac-cain13/R.swift.git",
        :tag => "v5.0.0.alpha.2",
        :revision => "2ba7dc0f175c824732e9fcd7aca9e152dfc34432"
    depends_on :xcode => "10.0"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
           "-static-stdlib"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
  end
end
