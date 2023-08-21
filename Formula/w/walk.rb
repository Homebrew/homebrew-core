class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "b42cc8744cea255e38e0cc605fdf4c32eb6e5279ed8430a7de126a82975553b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36a67968ef576e3c1758caa622268ae412bc6a7ec9e35a392f20fba98416fa3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a67968ef576e3c1758caa622268ae412bc6a7ec9e35a392f20fba98416fa3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36a67968ef576e3c1758caa622268ae412bc6a7ec9e35a392f20fba98416fa3e"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c1eca7e0b68d1dabbcae2c22018c3cba2dd49929412918551fe34d7301d5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c1eca7e0b68d1dabbcae2c22018c3cba2dd49929412918551fe34d7301d5c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1c1eca7e0b68d1dabbcae2c22018c3cba2dd49929412918551fe34d7301d5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af035db0a2bbd2a3d63528558d898304d45a737ef5bb8360606ddef05490ed9"
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
