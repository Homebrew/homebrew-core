class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/2.0.0.2/sfk-2.0.0.tar.gz"
  version "2.0.0.2"
  sha256 "2927eb23a8eb190a070c871141d3b2de491b174031dc88af3eec1877506afb3e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b968c7d588dfd85de2acc8b22b3fc69987ce043cdd49ed23cda86ae776807c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f93c5d0f82c21e9d0f25c3689b94fa47fb92eb8a31b10d5884f5b61276ffd7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3046f0abe948e34f45d68881da6eeb5847aca127ccb5811af2cb746d65a0987"
    sha256 cellar: :any_skip_relocation, sonoma:        "c482414e9117080567a7256cdf3de10162badc5858f23e7aee4036ab03f2911e"
    sha256 cellar: :any_skip_relocation, ventura:       "deea0ecf5b9e43e2d4a65c81d2a4875326428a2807ebf65dcbddc24bd5c2e15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3eda49d5a973827a028be4d1fda1437906d5e2efa1db16f362ca7347e64b56"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"sfk", "ip"
  end
end
