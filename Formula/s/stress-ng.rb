class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.05.tar.gz"
  sha256 "9712c5505602c6db8017c15a2659a3185f5a4f81ddde745e9f45f9e10a9f86c4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51bff89fac751ad70783008d591fd943f43da41d45fc89159ad842e0820e9cf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545c7970c0fc5fe6deffdc534819141865f05c3795ff539b815ae537815e1f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a80bd7083963d0aa4b3da32abcbb61909913294271be535e9f195a3efce5ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "794f61287f06139d75167154e0cf27a1e12ad2dce33a26bddb15195399929ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b7394cba2eebf678c6494916cd69c6149c37e46cca698f3c134ed4a6d59a247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90dd1bb48c3fe12248e4af56ab9f5b39066ebf809086fd5074862526ef6dd1f7"
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
