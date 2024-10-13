class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.05.tar.gz"
  sha256 "b0ac75b68bb804fd3276fcb235f1b0a9567090ebd887b2ed0f8a3203f9545e11"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35852366af74080e3fea366236a4c617f8097e26c8c13adac6e021545e6204c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2ab25767322c12e505db953a9eccb4a98e85f34af77c1a3b51f343dbba9c28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42dbe1fe2f175a029e35f7956ee507f152692f86002a7880726409472bfb4d03"
    sha256 cellar: :any_skip_relocation, sonoma:        "5597f486bc15243f3f75f5b0cab5b31aa0eb1b6feab9b4d4716e0513ec752db6"
    sha256 cellar: :any_skip_relocation, ventura:       "3fd9f6d70914d7f3a251ace43f03560ad5d5c5b1e119ce5d6a4a3d860b363aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c112f947da518bdf5883a9b737e9050b6d5301f61c47eb36a1c6185086887daa"
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
