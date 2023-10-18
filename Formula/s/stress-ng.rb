class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.00.tar.gz"
  sha256 "eca62128f4918edc6d1e309f426a223968f44b304b737275443ec9e62855d42e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15878746c59e68b1b24ae5611d1a6b76650789c5180b135d1c50c970aa9fe4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d560afedb5a04ed8d3318b2ad50c636e07687f8f22a68319d31d01b9cc0d4ba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca6c941361c978516f6d2263325edf61df02659063f85b00e3aba5ddf7f30fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb8480909be4eaea7f37d5f1a935623448eb3e3f85831b533c31051efa19ed02"
    sha256 cellar: :any_skip_relocation, ventura:        "5c61487816b7df7f92ed0bcc3fd982cc05c76287f93b79a1bc3f65f60521b8b4"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef269640070a6d1d2160c65612b8138b352434f430f8c172904b21fa29b6f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8070a92907f6910df35e05443fe531a6305b9dc18e1483d5f885940674b0615"
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
