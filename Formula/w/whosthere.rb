class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4ba8cc20a19c8d75ebd16cf61e08a82ce4cc8eff0031b52dad1eac49e3ff45dc"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee3f9bb7a581be90a013890fa970637b03893a1a7578eb589ffdf85e958f01c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b116f187f5b46ce4691b2f7d932f3ce1a77581d15c530acd3bb0994c3408cfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8df05911bc7bf0df40fe07727411244acc6c8b4df3999f0f8208f0c064dfa143"
    sha256 cellar: :any_skip_relocation, sonoma:        "291062c9fcd64fe25151f7e7a42d17b2bc4138aa41d0fa5b618c5419293d0c08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc7967059d2b03bf068200f30ca43ecfd4a1e78c0c7cf6d7f39a2b27afb7b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5526ac3806f032b5b99afdbf1f098269d19144779a7e156f680467be4d82ac64"
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
