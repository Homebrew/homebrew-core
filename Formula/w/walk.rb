class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "76e8db66942af53447f5ab3f0aaec49b539a68714130e46c83a01fff9c00438f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "02e5c4a1735ed885a6872fc4ccf6e3564034db333d89308cfe9fa7dfff5f33a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26feea01c5cb38433c8ce7315d8468801884c8b8e9b6f73831601520c3416356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26feea01c5cb38433c8ce7315d8468801884c8b8e9b6f73831601520c3416356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26feea01c5cb38433c8ce7315d8468801884c8b8e9b6f73831601520c3416356"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcd42a74a23b00ffd108f9ca708e4e7d11c5536cc11fc70bd9bce11f63362968"
    sha256 cellar: :any_skip_relocation, ventura:        "bcd42a74a23b00ffd108f9ca708e4e7d11c5536cc11fc70bd9bce11f63362968"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd42a74a23b00ffd108f9ca708e4e7d11c5536cc11fc70bd9bce11f63362968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f8f77276754f9af5dbd89bb76e295f60cded9536ba391ae0e5718c7fbd9669"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"

    PTY.spawn(bin/"walk") do |r, w, _pid|
      r.winsize = [80, 60]
      sleep 1
      w.write "\e"
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end
