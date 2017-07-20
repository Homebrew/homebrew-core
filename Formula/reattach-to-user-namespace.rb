class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.6.tar.gz"
  sha256 "80f5640a53823e39f87cc78a7567f38dd3f440f9c721e4929fde77dae6b71eb5"

  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e03dead8ceeaead3e996b30275f9b76ee912f47110037405a3504d94352eeca1" => :sierra
    sha256 "32e211dc568925e01d410ba4bef4a508d529ee553e9bf2f4d10564d11fb9e550" => :el_capitan
    sha256 "7e2cfb5efe7a03dd9cbf230034996caaf2206da05f2e5f771b9f289416907e45" => :yosemite
  end

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
