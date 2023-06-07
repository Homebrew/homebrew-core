class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.8.1.tar.gz"
  sha256 "0b3f77e4d5d7c909302804da22c1327c13d7002e10afe6435c0db659c2fe4f8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcd46ea00bab177fd432ac57c9437296c2f78bf8365d4af27455001a33fb1b6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcd46ea00bab177fd432ac57c9437296c2f78bf8365d4af27455001a33fb1b6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcd46ea00bab177fd432ac57c9437296c2f78bf8365d4af27455001a33fb1b6f"
    sha256 cellar: :any_skip_relocation, ventura:        "ab79ea1e4d0c4d10912b3baa9e04c25abf2b32ecfa16638efaff1763af2f31d9"
    sha256 cellar: :any_skip_relocation, monterey:       "ab79ea1e4d0c4d10912b3baa9e04c25abf2b32ecfa16638efaff1763af2f31d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab79ea1e4d0c4d10912b3baa9e04c25abf2b32ecfa16638efaff1763af2f31d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6928623746c8960de09b60b88bd84111fce4e691bad00786dfcb170fab7e27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
