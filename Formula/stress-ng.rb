class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.01.tar.gz"
  sha256 "cd4795166867eb4dba7cc11f246660d444b414afdb4033401ef5545a8e00776e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cef3fce1752f55d80c5ec17cd02884ad129cef371ab15e0d8d677a46fa54d60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48317638a24525fd5a1e6d4279b1a23dbb3de7922e96773cf5d43e8608ed95ce"
    sha256 cellar: :any_skip_relocation, monterey:       "261ac1ed0712aa23b2119f4e7fcd62d8e2cdca6dc5d07ca5b14962f4a959ccd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e466cab2063a41cff34826b6eb95a714b9110d2b6d9ce435f2193a5c9207861"
    sha256 cellar: :any_skip_relocation, catalina:       "19274fd86a07aa9178a8810b56e72935f39f7a8e799221efd7b0aecc39a0618b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d98573f50516cea506dc8dd2681613ebb0173ead526f543c51bbf6ac23b0f95"
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
