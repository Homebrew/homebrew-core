class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "97c15951f73812e88974c2922cd22756b39d0ba73c04fdec0fafd919f46215d5"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0da8786e67ceee07cf999ba9d4f7b9499d66d35879384510ab910f63156365e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02976cb7c20660e972135aca778b36a356d010fd36714e4cd3b5207ed7082da9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c41bfa167445efb04e6c6cd108821b00e3d8e72e0534e0c10bd95b5890dbf12"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4137c1a2c4f42c91c5726b5dc8fc8bee13991b1e0c43e40a0682500e496df98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4df7ed535fc9dcc8fb76765e8c90fa2e6ac1793f3e9090eaff602bdbecd8a202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8ba8e08fe063d4817fe84361de5924c61d8e01ef94b1ea1a0dbd90b01ea3f5"
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
