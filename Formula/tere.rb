class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "000d597c731f7c69175c6c50ccb20a3f508122e678b46d9fd89736ff7f0ea60e"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dda3e5361db146a16ee3d6db49f4b8f3d70d1aa2d01a3a47b2436b0977246d28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "463130ac457cd868b3a24a33dc44a4032ca43a8a56b42ab77bcced2300816dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "fe490bbc6410f9c6ec77aae2cc72d5e59a0282633cb418e1ccc31325cfdc3501"
    sha256 cellar: :any_skip_relocation, big_sur:        "126f7949c17d719a6507245d090bdcd5cff46731e482bcae902fd3fc539b0bcd"
    sha256 cellar: :any_skip_relocation, catalina:       "493c43c79a145932fcc0ebe5e2d55e3efb60297c1348d86a5510b56837ceedbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da9db180e3601339e420fad98c6ae7e48ca765c1ace8f90bea600025145174a7"
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
