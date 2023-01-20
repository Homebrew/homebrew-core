class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.03.tar.gz"
  sha256 "7cceca64da37fd3c8db7167ed386fd7d3e1d9d6891a1f6227911ab8d4b17379c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "426e1734959c9b02ccd589685510cbc34ff4cb439dfc657d9953c9d8e110eb82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a3e16935e9c310529a3a0d94197b0838a9b72b034fdc4b287382e72978dc70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2265ff2d0fdc96a7de3af555fc0b19905c2f3dab5138e2ebf1b4e3829ace8e1a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b9b11073f246b051b7876de0deaeea3212391c91c15a81c4d1a78c13fd54e6a"
    sha256 cellar: :any_skip_relocation, monterey:       "e9fff741703e5401db86f6a9920065f4124f0535d27a3fcc2ef3447250a0a7d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e7e4e67d947ca7b28ed708d178350398ea41119d75d05ac6a057bb0853522ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b450417dd37dd748b568c3804c980868069cc7c7258526662952bec2bad10e6b"
  end

  depends_on macos: :sierra

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
