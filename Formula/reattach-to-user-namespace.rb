class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.7.tar.gz"
  sha256 "7b49536afee3823065cd0772d5110d6814fafa9e8b66432ab537b3e891f4b202"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ced8c1497d56fc6b4c4d85d55ed38cd5c9785ca304083c4c72271776a9c8cba" => :high_sierra
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
