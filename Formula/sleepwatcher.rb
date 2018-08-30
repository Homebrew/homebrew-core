class Sleepwatcher < Formula
  desc "Monitors sleep, wakeup, and idleness of a Mac"
  homepage "https://www.bernhard-baehr.de/"
  url "https://www.bernhard-baehr.de/sleepwatcher_2.2.tgz"
  sha256 "c04ac1c49e2b5785ed5d5c375854c9c0b9e959affa46adab57985e4123e8b6be"

  bottle do
    cellar :any_skip_relocation
    sha256 "43b0b73e895cdd2bcaeb353ae65002642d400004112878df4fbf31ecb1cd5143" => :mojave
    sha256 "f9683fbee55fd410cd2650b2e12a01a322e316ceaf39484e5faa4ca3bec25ea3" => :high_sierra
    sha256 "b9ebee67696518e4d79efee6e8d564de9b6ccc67fbfea07f68b264b8c6a2a80a" => :sierra
    sha256 "d1abbc5f4752f77a01b1dfbadf831f58affc245137535d030992bd5cd3b1dd9c" => :el_capitan
    sha256 "e4e3d7f9802dcf14431334c3187108c554c5315b3e34bc03dcb76e8f181158f5" => :yosemite
    sha256 "b59893325808df64d3944f9aef6c66f6420d16cba36a2a1934bb8260bc27fe2f" => :mavericks
  end

  def install
    # Adjust Makefile to build native binary only
    inreplace "sources/Makefile" do |s|
      s.gsub! /^(CFLAGS)_PPC.*$/, "\\1 = #{ENV.cflags} -prebind"
      s.gsub! /^(CFLAGS_X86)/, "#\\1"
      s.change_make_var! "BINDIR", "$(PREFIX)/sbin"
      s.change_make_var! "MANDIR", "$(PREFIX)/share/man"
      s.gsub! /^(.*?)CFLAGS_PPC(.*?)[.]ppc/, "\\1CFLAGS\\2"
      s.gsub! /^(.*?CFLAGS_X86.*?[.]x86)/, "#\\1"
      s.gsub! /^(\t(lipo|rm).*?[.](ppc|x86))/, "#\\1"
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
