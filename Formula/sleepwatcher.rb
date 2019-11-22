class Sleepwatcher < Formula
  desc "Monitors sleep, wakeup, and idleness of a Mac"
  homepage "https://www.bernhard-baehr.de/"
  url "https://www.bernhard-baehr.de/sleepwatcher_2.2.1.tgz"
  sha256 "4bf1656702167871141fbc119a844d1363d89994e1a67027f0e773023ae9643e"

  bottle do
    cellar :any_skip_relocation
    sha256 "45c9c42ac76f9e9f85b0dbc2cb2251fe74448322196ac0ba10b93c416121db2a" => :catalina
    sha256 "eb160c23f9d92aed8d4bdfa24607a5bb343ad65dd487cb7a8570ac479bd05dd7" => :mojave
    sha256 "2c050aa5845cdf24b06f17bc1b4191941e4cf57cf1092f17fe35fe0e7f28159a" => :high_sierra
    sha256 "0cecea617ee9334f717a2e2e0424b944dedcc7cd403776c1cf6ff67352b96f4c" => :sierra
  end

  def install
    # Adjust Makefile to build native binary only
    inreplace "sources/Makefile" do |s|
      s.gsub! /^(CFLAGS)_PPC.*$/, "\\1 = #{ENV.cflags} -prebind"
      s.gsub! /^(CFLAGS_I386|CFLAGS_X86_64)/, "#\\1"
      s.change_make_var! "BINDIR", "$(PREFIX)/sbin"
      s.change_make_var! "MANDIR", "$(PREFIX)/share/man"
      s.gsub! /^(.*?)CFLAGS_I386(.*?)[.]i386/, "\\1CFLAGS\\2"
      s.gsub! /^(.*?CFLAGS_X86_64.*?[.]x86_64)/, "#\\1"
      s.gsub! /^(\t(lipo|rm).*?[.](i386|x86_64))/, "#\\1"
      s.gsub! "-o root -g wheel", ""
    end

    # Build and install binary
    cd "sources" do
      mv "../sleepwatcher.8", "."
      system "make", "install", "PREFIX=#{prefix}"
    end

    # Write the sleep/wakeup scripts
    (prefix + "etc/sleepwatcher").install Dir["config/rc.*"]

    # Write the launchd scripts
    inreplace Dir["config/*.plist"], "/usr/local/sbin", HOMEBREW_PREFIX/"sbin"

    inreplace "config/de.bernhard-baehr.sleepwatcher-20compatibility.plist",
      "/etc", etc/"sleepwatcher"

    prefix.install Dir["config/*.plist"]
  end

  def caveats; <<~EOS
    For SleepWatcher to work, you will need to read the following:

      #{prefix}/ReadMe.rtf

    Ignore information about installing the binary and man page,
    but read information regarding setup of the launchd files which
    are installed here:

      #{Dir["#{prefix}/*.plist"].join("\n      ")}

    These are the examples provided by the author.
  EOS
  end
end
