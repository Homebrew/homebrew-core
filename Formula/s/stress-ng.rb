class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.21.02.tar.gz"
  sha256 "71502d31f77987c3bda6931d47b44d7b03d8ac689e8154bbda676cf9d42e2b4e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d09870a6824e86884912f1981ede4309decbfb32e8f53f1dae55f049fef93c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb17e3018d6ee97446aa699b2e83af376a2475225c33ca4dc7e14fce3ba4e14d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e57ad7b67300d652895ad113fab9e7fd4fb193d4e72c10f3d66439524976fc5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca23301b472a3177757f1178e4638b8da697be8691fda7eacb5f0e1786ded2f6"
    sha256 cellar: :any,                 arm64_linux:   "42069a699d9d9383bb3aec28a39a643b89e61f8ab4cbe5f9a0c1f6f1cee5c40c"
    sha256 cellar: :any,                 x86_64_linux:  "9b7d608fde2894b0fe4e72bcbd62f489407b6498f5350cd20cd282721e108f3c"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

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
