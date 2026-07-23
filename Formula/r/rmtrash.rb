class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.8.0.tar.gz"
  sha256 "308c0bd8622b9410dafca183fdf405fdb3c4e2ec02e93fb5477746bdda3d10b9"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "981d9f56266fa946aa13d353f85b897961e11e60438000d7cb7d20186eb210ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29262f0a97d2e0e0066fd86d80587ca2306b3f66c63947f9dd608c8d5f79ca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "217eb7351e39dc3553e4834a4fdf1f01f603dc86db955ae0defa27b78677b2e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb6c059ab5d39f941f94f80bc1556f3beac4b17e39590b35016c53c01be34928"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rmtrash"
    man1.install "Manual/rmtrash.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmtrash --version")
    system bin/"rmtrash", "--force", "non_existent_file"
  end
end
