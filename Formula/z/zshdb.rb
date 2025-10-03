class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/Trepan-Debuggers/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.1.4/zshdb-1.1.4.tar.gz"
  sha256 "83749450ffe030c28e7b7d1d8b06aea63232504ff61f31f9becc5a5717e69638"
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",  # COPYING, lib/term-highlight.py
    "HPND-sell-variant", # getopts_long.sh
  ]

  # We check the "zshdb" directory page because the bashdb project contains
  # various software and zshdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/zshdb/"
    regex(%r{href=(?:["']|.*?zshdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "642ce820ac874107e1e57211b1ddc3b34df5da556da39706cdd5fb8f3bee9c26"
  end

  head do
    url "https://github.com/rocky/zshdb.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "open3"
    assert_match <<~EOS, pipe_output("#{bin}/zshdb -c 'echo test'", "exit\n")
      echo test
      test
      Debugged program terminated normally.
    EOS
  end
end
