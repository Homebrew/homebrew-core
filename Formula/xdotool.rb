class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/releases/download/v3.20210804.2/xdotool-3.20210804.2.tar.gz"
  sha256 "fde6b15b5978c91e0ecb78cc541a9987752e724820722e479dcc2efc17466c89"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a7a447517125966462a4b067fed71b0a2d5dca85f6e9b3348c47080b0754b043"
    sha256 cellar: :any,                 big_sur:       "0e34fac27796de7761ec3d82feb73231153535e5dc1ccbd71347b588fe2d70f9"
    sha256 cellar: :any,                 catalina:      "98d00ab9149f1d444e99dda25d190fecfbefb215ddf477f05b80a5aaf96ba24b"
    sha256 cellar: :any,                 mojave:        "d0b162c67f2a64735fc940c371d06fd7fcbf36e17453895fd16bcebe00f40056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5022406d6ac7bad0cb166ea02c9503fb07e2c32ebe03b928d18e991ff8f2adf"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  # Disable clock_gettime() workaround since the real API is available on macOS >= 10.12
  # Note that the PR from this patch was actually closed originally because of problems
  # caused on pre-10.12 environments, but that is no longer a concern.
  patch do
    url "https://github.com/jordansissel/xdotool/commit/dffc9a1597bd96c522a2b71c20301f97c130b7a8.patch?full_index=1"
    sha256 "447fa42ec274eb7488bb4aeeccfaaba0df5ae747f1a7d818191698035169a5ef"
  end

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
