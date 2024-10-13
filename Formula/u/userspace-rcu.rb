class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.14.1.tar.bz2"
  sha256 "231acb13dc6ec023e836a0f0666f6aab47dc621ecb1d2cd9d9c22f922678abc0"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "65972083148d5ab73483e2693fdccdf899a58707180f8b246068c4318c5a9049"
    sha256 cellar: :any,                 arm64_sonoma:   "2ed8fcd800628a4ddbc7cf232c63a30418f54ddbab8850a9ea5545d0ba381ced"
    sha256 cellar: :any,                 arm64_ventura:  "8206685594f05c7e98e72dbc992c2071f53ef365d88702b8e5fdc0a117ada212"
    sha256 cellar: :any,                 arm64_monterey: "f1ed0e9b4723760d12af588e6b8f1b8a3cd999c6c00711f930a08dd08df67365"
    sha256 cellar: :any,                 sonoma:         "b858e19e7ac159dfa8e359b7b9266e7e857f05a0970de371134bf5a2c865de70"
    sha256 cellar: :any,                 ventura:        "6e63de2ba3d3f2834fec3b7cbf3f3d33da14b8688b7336b71af0a5bb1a580971"
    sha256 cellar: :any,                 monterey:       "44770bb923e56f01f834089fcf7b7f27a6da1ccbb0a3efb93630e884008ab25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd1530224968195efa1996713ce9e76241ab247a686ae4d3efba8f04a1108d6"
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
