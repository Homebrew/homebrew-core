class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/RobotsAndPencils/xcodes#readme"
  url "https://github.com/RobotsAndPencils/xcodes/archive/refs/tags/1.4.1.tar.gz"
  sha256 "fe042ea365da9b7e1f6dca6cbeda0c54179b4d284ecb3a0ea70cd7bf6c4edb2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64ed372b1b209098ade04b0e6ba7ab54538b24d94c75e16227b3c1ab0b7838f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af680a02d22517629d5c4fd0c440fbed8cef6db05777607fa9c2958fb4cb7184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d45e1d801fff440ecc7ac2375989d24f656b7f69152f2d10c8f51305395f4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8323cc4e8d1fce55d1cb7531f32d502d1a886640b16e145391e3c1ee94222624"
    sha256 cellar: :any_skip_relocation, ventura:        "12bf7e26e4f33ec8debaf7c7b44d6236474120ac2be40ba57346d5539af1e4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "f44885b0a61b1d094eec3f3660b4a5031ec2006d749264ba5a764db632cdca50"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
