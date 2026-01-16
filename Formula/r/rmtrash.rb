class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.7.0.tar.gz"
  sha256 "b113bf35bd7e3d50e9dc1bf5959825614d5e81b1f2b64a5c8691e46ccfac7cde"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50452ef2115a802bd88467f7c1fde1fd3103ed72bea1b51561a0b8b74c405883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fca3148cc443cedd8c58e959ed175c1dc0881c016726fdeccdd04e70e3fd480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b3576b72e0af7f7bfa1758406abca0eba72f43a0e219cf39806de534f90738b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ef2f92366c7ec747ec2b2420ce909617b9b1b481735c6c5018917b6fa86370"
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
