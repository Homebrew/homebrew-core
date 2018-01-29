class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://lttng.org/urcu"
  url "https://www.lttng.org/files/urcu/userspace-rcu-0.10.1.tar.bz2"
  sha256 "9c09220be4435dc27fcd22d291707b94b97f159e0c442fbcd60c168f8f79eb06"

  bottle do
    cellar :any_skip_relocation
    sha256 "8de5176017208831ac20e6dd38a60ea20a15a3dd46a9e50063f88dd93faca0a2" => :high_sierra
    sha256 "91a85a96f02b0ecce03a309176a6b3280e3c07e1ddd18ec24d854270b5ca413d" => :sierra
    sha256 "f863137f145e61f8e2cd270e46951f426e12448de3ad978a2d69b6f75b479038" => :el_capitan
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
