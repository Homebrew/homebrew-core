class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.7.tar.bz2"
  sha256 "2556b83adc0f9b3ac8024e613e17d014d04c4c49110604ce55fcb14eae32edd3"
  license all_of: ["LGPL-2.1-or-later", "MIT"]
  compatibility_version 1

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "68b34be21a66be2be09b09cf39dce0f85bc05be306093f1aded8190b3bd71b94"
    sha256 cellar: :any, arm64_tahoe:       "a112628bb9224bd25d2485aa60a61280930b5667da277078726d4fe19972e067"
    sha256 cellar: :any, arm64_sequoia:     "dbd1786c178ec2720fdedef306099c333843cfdb6971672711e9e38650bb3dd0"
    sha256 cellar: :any, arm64_linux:       "75add8419e6127b41c9f16a910172bd0ae3a4c39a71353204736a613ee57d9df"
    sha256 cellar: :any, x86_64_linux:      "e6740da2ad7f0accaa6992605ed6c5db2120d4be237fe54195fd9f278ed81800"
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
