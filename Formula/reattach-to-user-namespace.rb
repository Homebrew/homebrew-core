class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.9.tar.gz"
  sha256 "e4df00ead6b267a027a4ea35032bcfa114d91e709b1986ec0cbaee6825cec436"
  license "BSD-2-Clause"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea86d8655e6e86620d1502bdf84edfb6950e4f36b2f6919541fcfe45817a4233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbf92257744971b555e6f1abb0205b5ee09986b47168d94f235b302974536b9"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef00eb2cd133afffbb67caef646fe99e8a8fb53ede9b8ddb6de1f20206760c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b715171e1c8ce8f86cddc241340a7a6f4f263e770d912894cf580790f8d8aa4"
    sha256 cellar: :any_skip_relocation, catalina:       "8ab11a5fa7512f5d7ef8fe62a5275325f3721e13fde2b0831d1f615e8820c341"
    sha256 cellar: :any_skip_relocation, mojave:         "b277145d5bfbc6997bc7d8ebe203e9d93adf8d1aa2f0f1c76152212ee6a23403"
    sha256 cellar: :any_skip_relocation, high_sierra:    "68e1f00743690086fb23ce013767e0a669ef46807ee9f618fe9ea4a25c50d5c0"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
