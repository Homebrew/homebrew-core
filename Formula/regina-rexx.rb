class ReginaRexx < Formula
  desc "Interpreter for Rexx"
  homepage "https://regina-rexx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/regina-rexx/regina-rexx/3.9.5/regina-rexx-3.9.5.tar.gz"
  sha256 "08e9a9061bee0038cfb45446de20766ffdae50eea37f6642446ec4e73a2abc51"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "c97635f3169b3c26ebe86c3efb2cc591c936052f4b06a71144488e5917b911fd"
    sha256 arm64_big_sur:  "959d6f80f93d13720130111f1f898b97b521affcbbc2b67b8540d5e518512a86"
    sha256 monterey:       "4bc6b21a904b70ae6775da17b948d54b0e1e78849d330c7777c1896b540cb0a9"
    sha256 big_sur:        "1c37cd2d7e0860ebabb477de8a89fb9debedcfabb5ccffcabfba1eef17b18a62"
    sha256 catalina:       "d132bc2537c7b8a07cd31fb9dc11c77e460243fd0bac5b6f69d3ab32e06f53cc"
    sha256 x86_64_linux:   "4f461dda1b7fc8a862c87509ad52cf525f6b4c02c15d33e07f5f7274a20e808c"
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
