class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "fafb6a69cf64593818c2944055b7a55572715f6136aa0b97767843b68c3556f7"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0946376455982d73d5113c149d7833ff5f11bf447a1a9837e555fa4131d57dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62af42fa9124df09d566db7e4accda20b3a66755c82fce542afd159a9624a872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc49388c8b0b29e32335dc7fce0a7f8d4f12b146981d244e4b34767497d39cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "307ed960c69cd44376d794aa7d1571ec49a9cd0dacf919fd7c6d16b2d9156f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3bd3a4796bf24bd03bc9a79629b0c379c1254c1c5a99a6139c820d102664930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561c04d83ef76ba0aefe83511225c4ac136ad126dfb22cd3b5171355dc0f589b"
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
