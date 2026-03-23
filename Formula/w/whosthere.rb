class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "73a7dfc2b31c74ae1fc0cf56d68fbcd6dfe47be53adfdafa5b00be17da7477d2"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8027b447af26eb0be09d508487e8c4e2d9f47a36e87ad68eab75d2395b8c8e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785fba47978cb781234f19c9ec74cedfb469755509722b939cc2354ebb62b286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cebeb5772a660730e18419d1d45a41418396dda1ece1fcc3dca23a93df60675"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdd285c09cfb4dc0cfcecd6df21991f8a7cb5bf3f5cf565a06a39f99829401e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1168abf65cc6dd46f35e28a58ff47a15f77b815d2865a077286d0e2efc5f5a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a7d652e131050bb8afba98def7809fb44668fdf2ee4a0613a952a4c3b76a06"
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
    assert_match "network_interface does not exist", output
  end
end
