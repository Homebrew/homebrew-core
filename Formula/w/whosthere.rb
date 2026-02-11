class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "d60367a6c51a7a59b2d282e547fced3393c7a6b4918b262aa015caf1211e1c91"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "136a4a9932cbcf9c21f123853afed1774a87529dd480ee27984b408b8ec0a9a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03805cb76a36dca0aa61e1ff00834def004db87d1e1a4be860670b4d35a85d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b485d842deb281905241897aaeaa0c1d86035c07c46346d1e2438bf2609550d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a22961ebdef5f72b697a62c6a0225c63f952382f448bcee9f66bfe15a2a245b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c90485e6adcd3fdefddbdd98c5d3d01072ad3b9060d1e0aafd4a5e22ba826eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f71111888eb72c2b6ee2561ba90a36fddcc5c858eac1c17ada779bf9e3a91764"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{Time.now.utc.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "no such network interface", output
  end
end
