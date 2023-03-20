class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/RobotsAndPencils/xcodes#readme"
  url "https://github.com/RobotsAndPencils/xcodes/archive/refs/tags/1.3.0.tar.gz"
  sha256 "0173718a67b07304300798d9fb90729617acfffa757840a55289e5241c621f07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "609d22093d1401820279ad3262dde90e6385ee659143df65bf0a7d393a206c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92f97acbcedde363cc8297f58f5301b37b56da77ae7fe0d61cec366a7a52546d"
    sha256 cellar: :any_skip_relocation, ventura:        "cab3178d02cbbff0b9a5be1edeb430af4166564ae458d1834d1667b982911fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "1589f9d3817627332ddaa3dc58de24bd8869198c3e728f8ba3b00562c634ae95"
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
