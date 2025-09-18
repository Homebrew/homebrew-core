class Tcpstat < Formula
  desc "Active TCP connections monitoring tool"
  homepage "https://github.com/jtt/tcpstat"
  url "https://github.com/jtt/tcpstat/archive/refs/tags/rel-0-1.tar.gz"
  version "0.1"
  sha256 "366a221950759015378775862a7499aaf727a3a9de67b15463b0991c2362fdaf"
  license "BSD-2-Clause"
  head "https://github.com/jtt/tcpstat.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "819e87c8105c753f181730fced67949dbc440e4a6e790c089f030134e6903ec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e7c67338b0d6c0f83589d31ce70046af5888a6bb752e5f2d69361d81b57ef99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05facda1f2a318b0253ef9b01500561ed6791d0b5143c5aeb05d1187902a6758"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c363371b5503288c97c1a00b5dc678aa2e121fc5470bb42676bb1c107fc7da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4126408cb79eaf56b14fb122539a770f8c593c90576c2f23cc6cfaef2a094f54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f5880a02d97d890364b5e98871dabb0682bf1d73d43f6a2cf92f0039f29619c"
    sha256 cellar: :any_skip_relocation, sonoma:         "54ea40debc75f08ad7120f8bccafceefea48cb0caa516f674a5d45f95cd84adb"
    sha256 cellar: :any_skip_relocation, ventura:        "64eeee455c63e53025d2bae91de42a412c3459afe2cd7c080f6ba272f66f2b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a031f93d9e107740f63c329da289a7b8534d168b66326f67b3f0dc5da82e6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8c9f2f529162b1b5fecee421aaa0c99b80864f752717142fb7f77c5f5acc43"
    sha256 cellar: :any_skip_relocation, catalina:       "86c1f5aad64e2d611dcb9d74b4eb0f51f24f79d1cdcaf636f62199099d625fa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bfd5b8071a1b3ad738db96ecd1ee944f6b58e781b9759cc9ec0d5be421fe99af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "036527a4c4492a1ca44c9b7c29ab1437108fc2c57105ade2f98fa8cf43a4e839"
  end

  uses_from_macos "ncurses"

  def install
    # Workaround for arm64 linux. Upstream isn't actively maintained
    if OS.linux? && Hardware::CPU.arm?
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} -fsigned-char"
      end
    end

    system "make"
    bin.install "tcpstat"
  end

  test do
    assert_match "Resolving", pipe_output(bin/"tcpstat", "q")
  end
end
