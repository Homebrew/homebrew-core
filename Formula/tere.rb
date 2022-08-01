class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a4ebd2f0b5728d6ec61749564106d67d74720fa05cb906686d559a5f15549698"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c90a30f6d79dd77be92534b3dbe0db18204798a2c6464b42544078867f8fd7b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "797b411bb4f8069362bc7809cad0fe149d1a1f57a32d0214cf1d6835e7469c31"
    sha256 cellar: :any_skip_relocation, monterey:       "42c122cb50d28655f99301d7edb9a3e6a449977810b99eaa347ebbfc5a31d3c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "12a353a4d351ac2775958546090e1a4a17a8048807cee5219250241176a473b8"
    sha256 cellar: :any_skip_relocation, catalina:       "0ace0a80b9b94ef938f79d71327a5f787ed5a8f3eefd4251c5b09135c07ed76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a04c0104dc6b03238944e3011c288935911439b65c99d0e0b488340a0ce67c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Launch `tere` and then immediately exit to test whether `tere` runs without errors.
    PTY.spawn(bin/"tere") do |r, w, _pid|
      r.winsize = [80, 43]
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
