class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.10.2.tar.bz2"
  sha256 "b3f6888daf6fe02c1f8097f4a0898e41b5fe9975e121dc792b9ddef4b17261cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a620b36743e9afeb795192e4d7defc2e581646afab160336f30182ef5458359" => :mojave
    sha256 "9e3e9a7e4615f206faab5567f4eeab37dfa0aad7bdb9113803716df70abb9e0e" => :high_sierra
    sha256 "a9e38da39a4afa118c7eeb9cadbb0466caea3f77a8525473a6603297b0d32a9f" => :sierra
    sha256 "e44fe1d83cedac0ccf9e22a406e8efac399ac281fbc858dbc20d7b57fe564503" => :el_capitan
  end

  def install
    # Enforce --build to work around broken upstream detection
    # https://bugs.lttng.org/issues/578#note-1
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --build=x86_64
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{doc}/examples", testpath
    system "make", "-C", "examples"
  end
end
