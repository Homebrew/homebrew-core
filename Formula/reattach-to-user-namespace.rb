class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.7.tar.gz"
  sha256 "7b49536afee3823065cd0772d5110d6814fafa9e8b66432ab537b3e891f4b202"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d5a844cd7ceac7d63563aa7359b5a9fc39ce91814d6dbd18d587b383ee549be" => :mojave
    sha256 "4771dbfd48578df075bcdc4d421826ffa648774bbf13362be723bbfdeb863668" => :high_sierra
    sha256 "e2002466693116bf3913fca2e4bc7977fe3d2be30af34d9bcbe2576105beef0b" => :sierra
    sha256 "da2f4dcaddf0d1035a9dfb93b6332749bad3378e7eac151f89378b4f7115802c" => :el_capitan
  end

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
