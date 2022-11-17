class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.8.0.tar.gz"
  sha256 "dad3a2140389f5032996e6d381a47074ddbad6e5d9155f72ef732952c8861a3b"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "625466bcd245a36da12ee088877d582c7e9fec1622418d1165a7d7d8f204ecc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883ba5ee45554568cd1ce106dc6c090ec0745f576a4a6708332de951b03c7423"
    sha256 cellar: :any_skip_relocation, ventura:        "70758ed628f4c6511bfd014f2e9d3bb37559c181ad7411bdbbbc3179f6c7a6d3"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd8c8e8d8927dfd4b83593f539690a6083b075b0a1ff8a66578e8bb810d3db9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d88edc1ae7db555ec5da01d4a1272da8260eb62073d2cdfa5fa3dce37d51fbe6"
    sha256 cellar: :any_skip_relocation, catalina:       "24a67cd4f2b66a02cb77a1c705d7dcf25b4410209435a0b1136398da1fa6f766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "961b2f3d75cf86dd5bc767cf689eee8f8e88bb30d716cf208b4bb89d61e5a553"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "./manpage"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
