class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.03.tar.gz"
  sha256 "7cceca64da37fd3c8db7167ed386fd7d3e1d9d6891a1f6227911ab8d4b17379c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e2b561871b3955c54c029848eb3976ee65409694a6320ae8a289b7aaf9c97e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc884a9717ddbbacf2a16928b34849bc33460fb1ac309693c6525570ec3ae0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c21c61177c973e1a7e3c5271df6431be7236a584a7077720ba5b10d5de2b096"
    sha256 cellar: :any_skip_relocation, ventura:        "ff92fc9dc0cd918bb0d79cd68de63d35197909e3e40a314e15bf145b9c8fc8ae"
    sha256 cellar: :any_skip_relocation, monterey:       "242c43597e5a779831c22043bbaba0b0c59ff77332a1c595a140776e0b649991"
    sha256 cellar: :any_skip_relocation, big_sur:        "9af524cc34cd4598a5d05d75c54f53f9ed619f89b3fc047e3f8da42875e3973c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483232b59ea55d97174955dbe96292911b3f77300defe1dad1c0ed1a65a53018"
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
