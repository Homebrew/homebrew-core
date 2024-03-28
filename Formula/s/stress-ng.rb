class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.06.tar.gz"
  sha256 "f81dc1ea7f2a821dab11e46cf3a3a893ad45299e51e6976041306871ddbc7f5d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00dce3eb713acdebe223aefb7dc2fd51413cf26c03afd1f162f1efc43126c957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcd1a366fb1f08d538afd62dc30a19541dca2a0169d18e87f58b240cb14009f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2f48c196d967c8eb38bd4fe367b5cc31b08d740067566bfb76e4b6ac516b8e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c4ff73a4289656f03043b13ccd76e94bbee8e7f7f36fc089cacca1cf9e6f87f"
    sha256 cellar: :any_skip_relocation, ventura:        "1de466ec79504cccc2396018b193c8cbad832c14f1a45446232f7e6ada2b241f"
    sha256 cellar: :any_skip_relocation, monterey:       "69f84562182bccb59432bf3cc2eaefcd0a8fa3606b89ddd483219b1957df36b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18624deca4848db86c54713ce3fbfa4f154dfe368cf2e3dd2fdf9154b3d96308"
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
