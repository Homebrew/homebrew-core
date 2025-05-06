class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.2.tar.bz2"
  sha256 "59f36f2b8bda1b7620a7eced2634f26c549444818a8313025a3bb09c0766a61d"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "909b0fe5d1c42ce94ba41db2031f73236afaf7774f6f46a1d45595992e7a6d28"
    sha256 cellar: :any,                 arm64_sonoma:  "ca36b22ce3d54f4027f040c32f9c57baf79fd808c293d5582042bc649845c0b7"
    sha256 cellar: :any,                 arm64_ventura: "2dc5698dd2089bdf247af9d49dc6471033a591413c09c50fad34bec13eb37a04"
    sha256 cellar: :any,                 sonoma:        "41e7b0d20a209b8ba60eac6057f07abdaf56651b4654e42ebf332a7588982c02"
    sha256 cellar: :any,                 ventura:       "7e741243e7a162d891f10f066ba53db5fe6c3a43161f43163c37b4044cfac991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbb45160931cef3a14c1a9f962ea959080c56e6de32da754d5dcbf2ec76bde44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240da85fe84ae40170bcb0fce2c1e72dfcbbfc068049d5ac4e7aa682083d59b7"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    cp_r doc/"examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end
