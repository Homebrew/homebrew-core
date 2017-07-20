class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.6.tar.gz"
  sha256 "80f5640a53823e39f87cc78a7567f38dd3f440f9c721e4929fde77dae6b71eb5"

  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be926162104571fa1eb1c1dda7a4f35f56c24cbdaceb037be4387ae86e7a7169" => :sierra
    sha256 "901c639c93b3f51d67891e748eed78604aceb6fec62812418e40fec009a731ab" => :el_capitan
    sha256 "1b7853288694d4ea8bff21141de050b1fa5be5920583ce4a472ac02653e6490a" => :yosemite
    sha256 "992f682ed9778b151164ade1a0fc67b85ce1368094c962857e0acbd408f6ace6" => :mavericks
  end

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
