class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.20.00.tar.gz"
  sha256 "fe9e5161ac186c6ada22963251ff701fe3275fac2c5b87bdb59c4cab08aaeaae"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67b233042d194cafdcc09842b4bbc260b9d2e0824eb8fd41bffeadda82f32f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40b54c7593e96e1b1d9b0d489e69a2822ad9494595695fdf00997c4b2b360bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d34b1ba0c2b78f25cde083285b698939392fd5117a40ed4ae3c2cb3530c7bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed50a3ae895b189a8bacfb7bca4b2d0dbfc3c57153510e46e69936152753199a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2784ed9479fedccdd949891933db224d373fa450534bb058ee41132a2e03515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab3ab7b4f6aafcd435e8db81c2010e1bf0a8e4ddb429eb255261e74e399252d"
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
