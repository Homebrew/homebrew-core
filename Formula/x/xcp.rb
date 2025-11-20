class Xcp < Formula
  desc "Fast & lightweight command-line tool for managing Xcode projects, built in Swift"
  homepage "https://github.com/wojciech-kulik/XcodeProjectCLI"
  url "https://github.com/wojciech-kulik/XcodeProjectCLI/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "399a1d4fab740ee7603d70c2df293611aafd71d7f00cdfd39588ba0a1566acd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "677b834448c32d70bb785251dba0934f7271c4321eed71f7de8a628236257887"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "494ab7b92214786f5ce6617b14f2e7181eec079f47c377a1461386c98eba2aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b6097428ce1bc7e3280a60f92e31f1f14d0ea4611d871b533e216d153d7d716"
    sha256 cellar: :any_skip_relocation, sonoma:        "2552a26db439c166b4f68497f8d1a65ec300ae2ee148a1ba78004e5c790bdb94"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcp --version")
    assert_match "Error: The project doesn't contain a .pbxproj file at path: #{testpath}",
                 shell_output("#{bin}/xcp list-targets 2>&1", 1)
  end
end
