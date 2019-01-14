class Wordplay < Formula
  desc "Anagram generator"
  homepage "http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html"
  url "http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z"
  version "7.22"
  sha256 "9436a8c801144ab32e38b1e168130ef43e7494f4b4939fcd510c7c5bf7f4eb6d"

  bottle do
    rebuild 1
    sha256 "d98d89abff244c21cf2ad4eb651ed39afea5b3146bf0ec3277483b813c4e8d89" => :mojave
    sha256 "9056fb79657b3be7ba8a97f4a13b1777e72447b717bd9fd1b7830023bda964a6" => :high_sierra
    sha256 "5141a8f5456e5a685b65c5d9f3100029c6f42b3f0c80aa3d6a4736d3028a6a6b" => :sierra
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
    pkgshare.install "words721.txt"
  end

  test do
    assert_equal "BREW", shell_output("#{bin}/wordplay -s ERWB").strip
  end
end
