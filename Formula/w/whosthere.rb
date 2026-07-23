class Whosthere < Formula
  desc "LAN discovery tool with a modern TUI written in Go"
  homepage "https://github.com/ramonvermeulen/whosthere"
  url "https://github.com/ramonvermeulen/whosthere/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "e6f4203fc62464e160349f342ff34103f89c6cb516d18ce6c7ba2bf6e398a2b5"
  license "Apache-2.0"
  head "https://github.com/ramonvermeulen/whosthere.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09d336e99331e1199db69cff3f257cb1b5dc1b92eb0f4de9fca7adca70456cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09d336e99331e1199db69cff3f257cb1b5dc1b92eb0f4de9fca7adca70456cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d336e99331e1199db69cff3f257cb1b5dc1b92eb0f4de9fca7adca70456cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffc45c503d5bbd30976f0fe4a22bdcb4880e44fcaafdf044ae56ca815a7d4469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3173ae505abccc1c3804d481b5f1958a128ebc971a3869f85240c408669f67fe"
    sha256 cellar: :any,                 x86_64_linux:  "1942a982f507d5fe27ac6db6ee0185537a1193b0c860f8c97e08a9f55149bfa6"
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
