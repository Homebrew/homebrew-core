class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d7f657371ffbd469c4d8855c2a2734c20b53ae632fe3cbf9bb7cab94bd726326"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54719b8dfd7e1d8d4f4c9b5169efeed05410bf4359b0262218032ded09275807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3142df42bb6de9d0cedcd83a22703ce70a69edb1d4950092673c4cabf04b5f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a3335ebce1d748e862505d8282bc7aa7d2434585b0e89546dfd8c56a3436797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92748578aa9afe0aba87e7f936ca4c342e8fdd78ec00f69a663abb930029e9c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1198b8f3118291e0eadaff8e960f1d850050efcae412959118f404a945ea2bcc"
    sha256 cellar: :any_skip_relocation, ventura:        "0c873d05896d3ac5491cbd8b484c2dbe2ac3633ff3840e1b025f4618c283501c"
    sha256 cellar: :any_skip_relocation, monterey:       "70e741a94ea5290b0e53fcdc3d8ce860d153180b3a311905ad31eea4a8f247f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ed3318ae636e59024e9e39c5e0851e50268265f17afe2f58b3f0ea21fd25df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78577c35467981482de8bfb2157be8d4d1c83bccad0574edae40c658cd784cfc"
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
