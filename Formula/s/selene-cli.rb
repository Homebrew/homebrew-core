class SeleneCli < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/zunda-pixel/selene"
  url "https://github.com/zunda-pixel/selene.git",
      tag:      "1.1.1",
      revision: "703adbc3fced409da7ecf20ea2b7e162ff6f4986"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/zunda-pixel/selene.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/selene"
  end

  test do
    system "false"
  end
end
