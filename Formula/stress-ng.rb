class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.08.tar.gz"
  sha256 "5dbb886f3926ef6c88e18cfd83c750f9fc11fb658f83b6eafcf22fd3a456cc8f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bb03a9c0ddfc9105ff82399499763d3434f8b9875bb1c862792467e9b672a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1617e8b6bc7c7a97c00936b3306584dede8002d935c9fc91de87815693be2cc"
    sha256 cellar: :any_skip_relocation, monterey:       "61f8bede2aa1ea8751b2831ae789c6868e6beccc5381e42827cd91c142f38fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "74ff3cbc32df74cb6c89bfea09366d935b09ba14515a7d77b94108c0109ffb5d"
    sha256 cellar: :any_skip_relocation, catalina:       "1878e0e632f9bdecdb7172aec3fe8a807460ddc516ba146bd6d667f0080fa8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80770a116a63a4ae1b5edebb1332ef7cbc380699cfae746a634a24150cbc2c01"
  end

  depends_on macos: :sierra

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
