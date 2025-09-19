class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.04.tar.gz"
  sha256 "3761ae901b2a81dcdb3f5363b8d98f288c03ae320a697b6d7ffef01a48845f05"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5929884e1fc3d0fd48044d49f78e08e4a063a5d8e9c7fe0dc6b0eb33e160db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f299a500d58baa7be598d2f44163c253c15ce70ddc665a47375412ce5e0f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e59089b8b27412c858d156cbe6047593904d0ad2639a89c8c2b17cb012e44c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba2497c3c73f7a74897e7e3aba416da97bb066cf1a9fa6b17be87998ffc36077"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6aee1a77635899ac6e21824e108353649afc2e383a257a34cfa046fbbd1ca26"
    sha256 cellar: :any_skip_relocation, ventura:       "28a6fad4afc428c804051be0aed158bcdbddd74926ca2dcbef39448464b9cacc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abe0aef12dd4faf7d1328b60faba819e6cae4aa40c4be72ad2f9601888ba5f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d2d805d44da3a4387efebc7182697e7ff372c4fa722b60d7ce3082f065d033"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
