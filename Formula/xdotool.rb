class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/jordansissel/xdotool.git"

  bottle do
    rebuild 1
    sha256 "341d016062ad7e0ffe416e8d70636a912ea62e8cfeae6bfd420935ed740c70a2" => :big_sur
    sha256 "a1b51b06df321f1fb0b43d81536bd0833579a0282aa6db5aab0d966c7ddcfd17" => :arm64_big_sur
    sha256 "2a11b0772f3ae332186d8d257c9687e759772d4e3fbe8a42e6fa07e9a5f11329" => :catalina
    sha256 "fd132f4ad55f7e709179a027878df3ee13d497d82ada355f323e2dd0b8f12409" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  # Disable clock_gettime() workaround since the real API is available on OS/X >= 10.12
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
