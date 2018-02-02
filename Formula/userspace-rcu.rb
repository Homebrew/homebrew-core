class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.10.1.tar.bz2"
  sha256 "9c09220be4435dc27fcd22d291707b94b97f159e0c442fbcd60c168f8f79eb06"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e3e9a7e4615f206faab5567f4eeab37dfa0aad7bdb9113803716df70abb9e0e" => :high_sierra
    sha256 "a9e38da39a4afa118c7eeb9cadbb0466caea3f77a8525473a6603297b0d32a9f" => :sierra
    sha256 "e44fe1d83cedac0ccf9e22a406e8efac399ac281fbc858dbc20d7b57fe564503" => :el_capitan
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    # workaround broken upstream detection of build platform
    # marked as wontfix: https://bugs.lttng.org/issues/578#note-1
    args << "--build=#{Hardware::CPU.arch_64_bit}" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "-C", "examples"
  end
end
