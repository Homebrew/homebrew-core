class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/1.6.0.tar.gz"
  sha256 "415c104c1aca42e68b4c6ede64e543d79a60d5a6fa99095f2aad179a74045047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26be4fc0a95c2af65e8f67daba501fb22196c76190a279a1df38edd891aa758b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6ae2f20d6eb6667c2e382beafd24afa6bfc99784c794e88e0a6005f4e5a398"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f52a88c7e9317257adeb33761ce725a8dee29da1fec73514e458edd445fa4e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e847c58f124ee2e6dadc821b7021edf0ab6cae564ef216b38c1e158faeeb7f"
    sha256 cellar: :any_skip_relocation, ventura:       "a48eb3978e5dbff7dd4f34245bb380bf56ef297c416b817140e54b53e31d10bb"
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
