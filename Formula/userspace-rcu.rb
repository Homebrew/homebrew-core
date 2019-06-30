class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.11.1.tar.bz2"
  sha256 "92b9971bf3f1c443edd6c09e7bf5ff3b43531e778841f16377a812c8feeb3350"

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
