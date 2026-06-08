class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "ecb42a6b5eae779da0d3db6d2889648cd58911ceee04907e81d6f625c9bbff08"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9c5d617398fe56cf7be46b69b2af48fee27511805b6c5c04f3d2ad4612afef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab9c5d617398fe56cf7be46b69b2af48fee27511805b6c5c04f3d2ad4612afef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab9c5d617398fe56cf7be46b69b2af48fee27511805b6c5c04f3d2ad4612afef"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4a7a15dc1046a905ea7670fcbcbba408980525cb65afde4d773f1129add182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6c8245f972626158faf7ea38536ec58986a36252283b3beb7558b5d1f4b9c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fa745a84ce6c50f69a3aee018dbb4d92a4c95bb2778209130428a44b2dc78c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionStr=#{version}
      -X main.dateStr=#{time.iso8601}
    ]

    ldflags << "-X main.commitStr=#{Utils.git_short_head}" if build.head?
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whosthere --version")
    output = shell_output("#{bin}/whosthere --interface non_existing 2>&1", 1)
    assert_match "network_interface does not exist", output
  end
end
