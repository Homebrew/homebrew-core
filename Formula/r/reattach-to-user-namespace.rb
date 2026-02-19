class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/refs/tags/v2.9.tar.gz"
  sha256 "e4df00ead6b267a027a4ea35032bcfa114d91e709b1986ec0cbaee6825cec436"
  license "BSD-2-Clause"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "33e476a85796e31103b568becc52eacb83185bc9cd763cde17d4cf1cc8ef7198"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cd39282391ec191e5421c47cf7dbc9c7c4a58ac1cf271d09b453d49e0068b3fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c946e781c18777b2156251b59a44f1db80cd39d59c18dce460011a0176566b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff12e77b3cfc11ea931010a16a2c1a1ffb4bd893b6644f29966507fcdbe02b8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea86d8655e6e86620d1502bdf84edfb6950e4f36b2f6919541fcfe45817a4233"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbf92257744971b555e6f1abb0205b5ee09986b47168d94f235b302974536b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cb86ce647f290fcc0752a0bc7d26776768a2fff11a9ec95c0bac3f82a137492"
    sha256 cellar: :any_skip_relocation, ventura:        "c84b1082f8e2b8b6b5d43b1fff674f6c32add385b7267a01b80fc74f154ed9bc"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef00eb2cd133afffbb67caef646fe99e8a8fb53ede9b8ddb6de1f20206760c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b715171e1c8ce8f86cddc241340a7a6f4f263e770d912894cf580790f8d8aa4"
    sha256 cellar: :any_skip_relocation, catalina:       "8ab11a5fa7512f5d7ef8fe62a5275325f3721e13fde2b0831d1f615e8820c341"
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
