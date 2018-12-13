class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"

  stable do
    url "https://github.com/mac-cain13/R.swift.git",
        :tag      => "v4.0.0",
        :revision => "0306ec185ad0f7753e9ea44fefdbf268d9e62184"

    depends_on :xcode => "9.0"

    patch do
      url "https://github.com/mac-cain13/R.swift/commit/082adb3a4fb3835507e61de15dabd2e9e1b547fb.diff?full_index=1"
      sha256 "6ebaeaeb0ad29ad94f1919683cc064455837a9d0e7b2cad83bc9011d60e6cf2f"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "89e99e0639822565f5f91d400b7f78a08a49d87c950b8a75ecd9bda0efa09d35" => :mojave
    sha256 "97c9578ab704ab2ded67969b5648c4d06410f86d976ffec7338196aa6d8f5bf2" => :high_sierra
    sha256 "8b65c8330b314a454a8c4304d585c5c5142557ef5d98bafcc9ccb40ea3655130" => :sierra
  end

  head do
    url "https://github.com/mac-cain13/R.swift.git"

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
