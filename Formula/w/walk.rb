class Walk < Formula
  desc "Terminal navigator"
  homepage "https://github.com/antonmedv/walk"
  url "https://github.com/antonmedv/walk/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "b6ba7a5e3873a25944e0f18c8a3ebbfdc0e8681756517905c75972c824315970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5578755af5859148ad9c163aa88bd3c7215f71cfd938f2b2bfadbd0d21d40248"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5578755af5859148ad9c163aa88bd3c7215f71cfd938f2b2bfadbd0d21d40248"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5578755af5859148ad9c163aa88bd3c7215f71cfd938f2b2bfadbd0d21d40248"
    sha256 cellar: :any_skip_relocation, ventura:        "5747b2a9e5f9147a4a00e05d07c1121b065603d46ed739dfa735fee2437522bf"
    sha256 cellar: :any_skip_relocation, monterey:       "5747b2a9e5f9147a4a00e05d07c1121b065603d46ed739dfa735fee2437522bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5747b2a9e5f9147a4a00e05d07c1121b065603d46ed739dfa735fee2437522bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0156820bc8b40bfa01252bf681616ae860db3cdb0eb53976b9546baf146db3e"
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
