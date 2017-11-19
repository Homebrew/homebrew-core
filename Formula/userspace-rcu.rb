class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.10.0.tar.bz2"
  sha256 "7cb58a7ba5151198087f025dc8d19d8918e9c6d56772f039696c111d9aad3190"

  bottle do
    cellar :any_skip_relocation
    sha256 "47c25f79337916fb5f0189ab22dbf463f63e1381287340742e90e426703dbd72" => :high_sierra
    sha256 "933037283d61c47bf57df657d15cb9ad787be3150a93baf79e81f7c07d11d7c2" => :sierra
    sha256 "d0b393a777b07767cef195b897777e9b65d9186e4307a2ce5a20989082a97976" => :el_capitan
    sha256 "2842341210131cff185ace17b10599eaa002fc60407267322749191ae5fa1fdc" => :yosemite
    sha256 "03e24c928b31060eecb8de113be45f0ae8d70ee20073d481a2244d10ae4d1825" => :mavericks
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
