class Sigviewer < Formula
  desc "Sigviewer"
  homepage "https://github.com/schloegl/sigviewer"
  # version "0.6.4"
  url "https://github.com/cbrnr/sigviewer/archive/v0.6.4.tar.gz"
  sha256 "e64516b0d5a2ac65b1ef496a6666cdac8919b67eecd8d5eb6b7cbf2493314367"

  depends_on "gcc" => :build
  depends_on "gnu-sed" => :build
  depends_on "pkg-config" => :build
  depends_on "libbiosig"
  depends_on "libxdf"
  depends_on "qt"

  patch :DATA

  def install
    # apply patch
    system "gsed", "-i", "s|$$PWD/external/|/usr/local/|g", "sigviewer.pro"

    system "qmake", "sigviewer.pro"
    system "make"

    bin.install "bin/release/sigviewer.app/Contents/MacOS/sigviewer"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test sigviewer`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/sigviewer", "--help"
  end
end

__END__
