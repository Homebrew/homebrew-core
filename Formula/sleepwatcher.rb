class Sleepwatcher < Formula
  desc "Monitors sleep, wakeup, and idleness of a Mac"
  homepage "https://www.bernhard-baehr.de/"
  url "https://www.bernhard-baehr.de/sleepwatcher_2.2.1.tgz"
  sha256 "4bf1656702167871141fbc119a844d1363d89994e1a67027f0e773023ae9643e"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sleepwatcher[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f1c692fe19acb2929dd41746c3a184efb36146039b3b9c4554a4ca7a3e0d55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c66d5808a4c8defb52bb8c9acf2584dbe542940bf758a53cae0c4d68229c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "5a6a9cf80d062199423619e15c9c32be29b1822cb49669ea89f107b6a58cd973"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad8d8729a86763e64a3f555c4197ad6048ee5b8c6589ce4f2763d60b9826bb13"
    sha256 cellar: :any_skip_relocation, catalina:       "6752791ceaab316af2e61c45a6ee5e1a7c05f326be64f31e4bfad412a216b413"
    sha256 cellar: :any_skip_relocation, mojave:         "651f17a7622a05db38a14b133c15e20f441028c2f540af104421f204a766238d"
  end

  depends_on :macos

  def install
    # Adjust Makefile to build native binary only
    inreplace "sources/Makefile" do |s|
      s.gsub!(/^(CFLAGS)_PPC.*$/, "\\1 = #{ENV.cflags} -prebind")
      s.gsub!(/^(CFLAGS_I386|CFLAGS_X86_64)/, "#\\1")
      s.change_make_var! "BINDIR", "$(PREFIX)/sbin"
      s.change_make_var! "MANDIR", "$(PREFIX)/share/man"
      s.gsub!(/^(.*?)CFLAGS_I386(.*?)[.]i386/, "\\1CFLAGS\\2")
      s.gsub!(/^(.*?CFLAGS_X86_64.*?[.]x86_64)/, "#\\1")
      s.gsub!(/^(\t(lipo|rm).*?[.](i386|x86_64))/, "#\\1")
      s.gsub! "-o root -g wheel", ""
    end

    # Build and install binary
    cd "sources" do
      mv "../sleepwatcher.8", "."
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  service do
    run [opt_sbin/"sleepwatcher", "-V", "-s", "#{ENV["HOME"]}/.sleep", "-w", "#{ENV["HOME"]}/.wakeup"]
    run_type :immediate
    keep_alive true
  end

  def caveats
    <<~EOS
      For SleepWatcher to work, you will need to write sleep and
      wakeup scripts, located here when using brew services:

        ~/.sleep
        ~/.wakeup
    EOS
  end
end
