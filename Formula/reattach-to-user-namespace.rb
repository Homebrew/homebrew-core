class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.8.tar.gz"
  sha256 "8b1b2785f2be19cc29083e7782270e6dcca67a66c66f11f785f4b26c446bbd77"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "165edabd70a4acbdee2f3e09e9a37e9ca23b2d485ebe12d62511cef9c45fd757" => :catalina
    sha256 "388e45300bf6cf3888a490878c9a03b97c06a52fe316a18d099ab97bddbed295" => :mojave
    sha256 "adc59ad02ccf302e9c71c08d10a4eb95d5d210dbfebe9a00b41648b094c96f09" => :high_sierra
    sha256 "1ec537d4be63bbcdaf3644506d0b272051fd2617db84c111152a33d8d0184339" => :sierra
  end

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
