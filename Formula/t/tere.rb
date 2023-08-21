class Tere < Formula
  desc "Terminal file explorer"
  homepage "https://github.com/mgunyho/tere"
  url "https://github.com/mgunyho/tere/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "84195f45b738fb7c805d7b348185658d0dc58aa26e7f92fcad9578bc7bd694bf"
  license "EUPL-1.2"
  head "https://github.com/mgunyho/tere.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3127d3aad6b0d14f520883ffbbd76094f12379a3eb90a3014cfb5df3dadc0b14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb69192a655ecdc6584b90910eba6508dc14ee6a5910b0fda2868810dc27b7c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a1c85a9135fc5f1a2d9287390eeb6b47ef9657b99020387c03d7586f3408c8f"
    sha256 cellar: :any_skip_relocation, ventura:        "c61a055f643e9b45a3ea810a75d950baa0e9b7cf3f3770dff9190864420e90be"
    sha256 cellar: :any_skip_relocation, monterey:       "35241180534467310032cd931e4ab56080e551b8fe3a8cac105e0dec0af08222"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c58eac7b1b9e1ea976dfd7fdd33a1afe94aacc82586e65c8e3f103a8595b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa494fe8026952a11252edf6191b3e4a1bf6ed19b43a50b64e25a119f85713c6"
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
