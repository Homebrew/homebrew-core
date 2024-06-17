class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b657523d637727cfa408040e9816f45ae868c5192fb3962c32a0edab9d9b00dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "537142d9f0227961b01d774084514fd724bc10789d6d237013ee7b23bb24f392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "537142d9f0227961b01d774084514fd724bc10789d6d237013ee7b23bb24f392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "537142d9f0227961b01d774084514fd724bc10789d6d237013ee7b23bb24f392"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac0112f53613cc4910ba605c8494150492352fb38d2a7b95e81e458ab021fbdc"
    sha256 cellar: :any_skip_relocation, ventura:        "ac0112f53613cc4910ba605c8494150492352fb38d2a7b95e81e458ab021fbdc"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0112f53613cc4910ba605c8494150492352fb38d2a7b95e81e458ab021fbdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0aec9f0061f88be352c10566a6513a9edcddb10d3034a417bf60e93f921002"
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
