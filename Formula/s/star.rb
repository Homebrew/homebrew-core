class Star < Formula
  desc "Standard tap archiver"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2023-09-28.tar.gz"
  sha256 "564ea2365876a53eba02f184c565016399aee188c26d862589906cf3f92198e6"
  license "CDDL-1.0"

  bottle do
    sha256 arm64_sonoma:   "57bb05fb4b7c8ee56434e530f856ffe4ec5939594633983dcf36cb20c5eaf111"
    sha256 arm64_ventura:  "dff7da95a2a96b372b0227602533290512c7445edf4a2e3ece9f56ce1eefc58c"
    sha256 arm64_monterey: "bc80d714e33b7f0f2fa8cc59527ec55cd68ef7bdf9d627fff987f717867092b0"
    sha256 sonoma:         "2519f9558ca33390544e937858e2d18033a8335e0d01a33e9090eca7272dfdf9"
    sha256 ventura:        "156defe7462aff7b3c3d2447311d7bd9d44a531509f7c6abe2f50bb1ad2f5e37"
    sha256 monterey:       "3f98c2eab8f8f56a786506b5d36034a7efb671339e007c28b2dbc6a1e818d144"
    sha256 x86_64_linux:   "ad6c7b60a278859ec533d13eee82a8565830384a7a571df01fceeeaa2235d489"
  end

  depends_on "smake" => :build

  def install
    deps = %w[libdeflt librmt libfind libschily]
    deps.each { |dep| system "smake", "-C", dep }

    system "smake", "-C", "star", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin/"gnutar").unlink
    (bin/"tar").unlink
    (man1/"gnutar.1").unlink
  end

  test do
    system "#{bin}/star", "--version"

    (testpath/"test").write("Hello Homebrew!")
    system bin/"star", "-c", "-z", "-v", "file=test.tar.gz", "test"
    rm "test"
    system bin/"star", "-x", "-z", "file=test.tar.gz"
    assert_equal "Hello Homebrew!", (testpath/"test").read
  end
end
