class Xcp < Formula
  desc "Fast & lightweight command-line tool for managing Xcode projects, built in Swift"
  homepage "https://github.com/wojciech-kulik/XcodeProjectCLI"
  url "https://github.com/wojciech-kulik/XcodeProjectCLI/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "73cab837bb54d8e5e1f589ee9dc31f9d6e14db15288efbf9d836115ff0807fe9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "175da42078cdac05a63d480ad12b95c6094f0e9cd43579b8ff7f70473db78a80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7dd0e22254bd2deb2c090be9a68b54c93eefdaa6404e9e003c8d2cc39c293d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8de30c2991a2cdcdf72c5ed8f09987e12ae0e228487f08d9669751af7b79cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "45a0e1d909070058a7004db2ee342b2f44434d4bee95ff8885bce823cd97692a"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcp --version")
    assert_match "Error: The project doesn't contain a .pbxproj file at path: #{testpath}",
                 shell_output("#{bin}/xcp list-targets 2>&1", 1)
  end
end
