class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.02.tar.gz"
  sha256 "45eac8d354df5be26c9675ec7fc24910f846e47eb6b151e9955d6eae30cfe060"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b5ef9e75a3e004647010a69d87c2e0d04aa62f4f3b6e7e3226ad4fb92557e88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2ac891ab2567c944f0df6d1295731fbc2dca4d8597fca7d49d968cb402e3068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5ef6fd5b535fb850b22fc8e12c9fdfa8f0a325478f5c4ffa8ec3bbf0733c6e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "50e04aef23c2c988cd373f22585ee66646e79383a1f654b412b6e9351b3b7916"
    sha256 cellar: :any_skip_relocation, ventura:        "c0d02be657d3f07f43d3e87f754313dc6bbbe6a287b4ef378b04e3496d7ed665"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf4f4970399a766a0d31e5a295923738de15eb14e2e2b55d2a8bec65415514a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756aa9014a7c5223bfdb7a9e99e400163a7e65688f0ac6a6e041941e0b74e29a"
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
