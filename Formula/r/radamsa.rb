class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://gitlab.com/akihe/radamsa"
  url "https://gitlab.com/akihe/radamsa/-/archive/v0.7/radamsa-v0.7.tar.gz"
  sha256 "d9a6981be276cd8dfc02a701829631c5a882451f32c202b73664068d56f622a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0af48b970749d3140a384b58a3a154d7a2f772c3de5b82053adca2bfc51548f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8925ac2d6e3c32b78ef09e0b3d7c0403f3a210b99138b1833e9c55db97db2392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f2f8360c3b5ef80433bf865cc828751fd4a53383ba92c7beb75ad629a63526"
    sha256 cellar: :any_skip_relocation, sonoma:         "28fcd6c2a92bf81253ea11ca472b188e8b793d2ef188a9d79a191893a985a193"
    sha256 cellar: :any_skip_relocation, ventura:        "bf286a9e8d072eeb26fe122b35f412e1a9d65d9594e4f7eca161d458f4f9d6de"
    sha256 cellar: :any_skip_relocation, monterey:       "3576947047fad8d865becded6957f1656ccae7b1c270f3dc6b2b3e660e09378e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4689407adfe023eb9ef82d62468d80460b1ce882066990b1d0decc65723b428"
  end

  conflicts_with "ol", because: "both install `ol` binaries"

  def install
    system "make", "future"
    man1.install "doc/radamsa.1"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      The Radamsa binary has been installed.
      The Lisp source code has been copied to:
        #{prefix}/rad

      Tests can be run with:
        $ make .seal-of-quality

    EOS
  end

  test do
    assert_match "Radamsa is a general purpose fuzzer.", shell_output("#{bin}/radamsa --about")
    assert_match "drop a byte", shell_output("#{bin}/radamsa --list")
    assert_match version.to_s, shell_output("#{bin}/radamsa --version")
  end
end
