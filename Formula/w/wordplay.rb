class Wordplay < Formula
  desc "Anagram generator"
  homepage "http://hsvmovies.com/static_subpages/personal_orig/wordplay/"
  url "http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z"
  version "7.22"
  sha256 "9436a8c801144ab32e38b1e168130ef43e7494f4b4939fcd510c7c5bf7f4eb6d"
  # From readme:
  # This program was written for fun and is free.  Distribute it as you please,
  # but please distribute the entire package, with the original words721.txt and
  # the readme file.  If you modify the code, please mention my name in it as the
  # original author.  Please send me a copy of improvements you make, because I
  # may include them in a future version.
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/href=.*?wordplay[._-]?v?(\d+(?:\.\d+)*)\.t/i)
    strategy :page_match do |page, regex|
      # Naively convert a version string like `722` to `7.22`
      page.scan(regex).map { |match| match.first.sub(/^(\d)(\d+)$/, '\1.\2') }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:    "52b1abdbfd94ea465505779f4c4b74e5cedc8729f60e2ba8ed5d598082d907d2"
    sha256                               arm64_sequoia:  "7117e25ad1d78a133f0ad6f3e68c7f203cf83387903e27d6346852b97b3c409a"
    sha256                               arm64_sonoma:   "9377c6a3b8e7db879c1cafa0a53eb303fe65e81259c2b99a912c5080fe1834fd"
    sha256                               arm64_ventura:  "e5046dfd7e922872308efed4f745399220ddc5f7f62f4d200748700d136e956a"
    sha256                               arm64_monterey: "28dcc7b1dd3d809b79e3b331309d2f3ebd4b23383e76813b0397dcc617527e48"
    sha256                               arm64_big_sur:  "5ce75cc234b4d54de31124443d207bae75ed01211cdb23770363efc0b984bc75"
    sha256                               sonoma:         "f2fb80006fb5b7fd74712bdbab04cf8ad2efbfdd17c7b023146a168f560e8570"
    sha256                               ventura:        "1074a6a9d010d50bfe73cea4fbafb6a2d7d90155057e1c25e90394533c9eba83"
    sha256                               monterey:       "f456578ef358b10b91008a83f42e6877a4daa32615588fbb3ac629d9db804c5a"
    sha256                               big_sur:        "086d078ef82bce278ad9bc25d901f1ffd3bd539aef410c7e81466b0616ef2c32"
    sha256                               catalina:       "bf3847365e1920baf313fc0286116de59fee392ccde5182173ed7198b9883626"
    sha256                               arm64_linux:    "40b8d661df34ff03a28922e62a862fa037d3b66925cd51528018f7f45de587d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e8e9383f4bbbe56afbd9d2c400867ecf0f229a3aa3431c5b809dd95ffd6a30"
  end

  # Fixes compiler warnings on Darwin, via MacPorts.
  # Point to words file in share.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/wordplay/patch-wordplay.c"
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
