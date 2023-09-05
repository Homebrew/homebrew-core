class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.5/regina-rexx-3.9.5.tar.gz"
  sha256 "08e9a9061bee0038cfb45446de20766ffdae50eea37f6642446ec4e73a2abc51"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "6808d74238b1b6ced2548b2f75b609a31ab765e7eefe76bdae1b3e03e1da15d3"
    sha256 arm64_monterey: "0b69b4673a59541d876b72172c6fca840366877557d30517e94cb67f51119739"
    sha256 arm64_big_sur:  "13dfb9942fd4833175a11ae4fe2796c74638ac8dd5e7e3a63777cd935f54fadc"
    sha256 ventura:        "b3c98aeb0520d525e2a1396c4fb8ecdace97bf77b916c1a218d61ae2db739ad3"
    sha256 monterey:       "3b4d201a4818ddf001577fd1086e3e727817fdf9a9602706a5f9f54fb7f40140"
    sha256 big_sur:        "688343997f1e418eac2c9d0b5142c0befedc3f74ebc6bd2472c2e10c825eaadc"
    sha256 catalina:       "fa2360dc87dedfa3dc8c0bf71577dc2e7f64e4b85847fa55c331d78e2f538151"
    sha256 x86_64_linux:   "ab70d6b3957468bd4486fa82da511b3b4cc8e23057827cec07d95163742fbadd"
  end

  uses_from_macos "libxcrypt"

  def install
    ENV.deparallelize # No core usage for you, otherwise race condition = missing files.
    system "./configure", *std_configure_args,
                          "--with-addon-dir=#{HOMEBREW_PREFIX}/lib/regina-rexx/addons",
                          "--with-brew-addon-dir=#{lib}/regina-rexx/addons"
    system "make"

    install_targets = OS.mac? ? ["installbase", "installbrewlib"] : ["install"]
    system "make", *install_targets
  end

  test do
    (testpath/"test").write <<~EOS
      #!#{bin}/regina
      Parse Version ver
      Say ver
    EOS
    chmod 0755, testpath/"test"
    assert_match version.to_s, shell_output(testpath/"test")
  end
end
