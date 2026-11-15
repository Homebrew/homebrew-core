class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6d7cc7691999a461535492ceee18bb7cfc1ad04d563123fb838de41712e85fb6"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36275c0ef5c5591103b816b7113993651e8f131db4206437a9ed090927a75abc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36275c0ef5c5591103b816b7113993651e8f131db4206437a9ed090927a75abc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36275c0ef5c5591103b816b7113993651e8f131db4206437a9ed090927a75abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cef4ed6489e9aaa4b52d8437e38bad33c500e4139ba01ba030eefaa50d748215"
    sha256 cellar: :any,                 x86_64_linux:      "777712d5c49f0dbf6f4c93cca4b250533ef215a8e776418c21de7f7493f4ed20"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
