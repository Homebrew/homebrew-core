class WifiPassword < Formula
  desc "Show the current WiFi network password"
  homepage "https://github.com/rauchg/wifi-password"
  url "https://github.com/rauchg/wifi-password/archive/refs/tags/0.1.0.tar.gz"
  sha256 "6af6a34a579063eb21c067f10b7c2eb5995995eceb70e6a1f571dc78d4f3651b"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a253b554c4b811b489e3a487f6472ab8c5b4f8df34d203ed5deab3776cd4ec1f"
  end

  depends_on :macos

  def install
    bin.install "wifi-password.sh" => "wifi-password"
  end

  test do
    system bin/"wifi-password", "--version"
  end
end
