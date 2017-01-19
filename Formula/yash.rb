class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "http://dl.osdn.jp/yash/66984/yash-2.44.tar.xz"
  sha256 "f1352b49195a3879284e3ab60af4b30d3a87d696c838b246e2068ccbdfcf2e66"

  bottle do
    sha256 "8d75a55e6407e3923818bbbdfb1c828261a867e75d9e995c98e6d1d043378ad3" => :sierra
    sha256 "ec6ddba4a680192e8bfd7ecf720f3cabc06e42e89345565a0e4a2addfc6e2ad8" => :el_capitan
    sha256 "f5fed4a3d7dfe13d817d02c5ce548c6bf59dddfd4b626c4bd971b41bed28f721" => :yosemite
  end

  depends_on "gettext"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--enable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
