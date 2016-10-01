class Wordplay < Formula
  desc "Anagram generator"
  homepage "http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html"
  url "http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z"
  version "7.22"
  sha256 "9436a8c801144ab32e38b1e168130ef43e7494f4b4939fcd510c7c5bf7f4eb6d"

  bottle do
    sha256 "217fcfc1df6ae5c4dfb339fa4752a76486a4820006aac76be16a64a2d12d103d" => :sierra
    sha256 "0f549555c287b010bd2936d355942e0b652e520a36b6a0c2b887516d08c9db36" => :el_capitan
    sha256 "693f5920e44376dfcb1535c7dfc61c1d01a5c707756b2f05ce015486e8bd6c39" => :yosemite
    sha256 "1255545f067e86a01a7958d212af815c155026cfc430a421555fceb1587b0931" => :mavericks
  end

  # Fixes compiler warnings on Darwin, via MacPorts.
  # Point to words file in share.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5de9072/wordplay/patch-wordplay.c"
    sha256 "45d356c4908e0c69b9a7ac666c85f3de46a8a83aee028c8567eeea74d364ff89"
  end

  def install
    inreplace "wordplay.c", "@PREFIX@", prefix
    system "make", "CC=#{ENV.cc}"
    bin.install "wordplay"
    (share/"wordplay").install "words721.txt"
  end
end
