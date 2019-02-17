class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.10.2.tar.bz2"
  sha256 "b3f6888daf6fe02c1f8097f4a0898e41b5fe9975e121dc792b9ddef4b17261cc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9a563f49d9a758f7f04b2aae28b1af9f83639f6f5ffa72b60530e6fd22e8ab63" => :mojave
    sha256 "c30de049c48f01c4d112f7cccf09b264ca212c12d8f26a4c25d365f63a165909" => :high_sierra
    sha256 "4a3935774671539cb2087954f8729a06f06b9d5402a9b24f9ecea29daa6d3b64" => :sierra
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
