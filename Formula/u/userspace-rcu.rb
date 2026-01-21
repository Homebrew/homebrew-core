class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.5.tar.bz2"
  sha256 "b2f787a8a83512c32599e71cdabcc5131464947b82014896bd11413b2d782de1"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8db2d4886358e3b6d13a2ba3559e765a164e70544e3245040b0b5e59763a16e7"
    sha256 cellar: :any,                 arm64_sequoia: "6a4555a5e2cb25997c1f624160e80940856f16fe7d57534a32dd1958f55cd5e1"
    sha256 cellar: :any,                 arm64_sonoma:  "3c1b50e1358fc358d10d51d33dc71d52b083bbb0ebaf189d1d2406e3db38a5b6"
    sha256 cellar: :any,                 sonoma:        "1629a8ef56adaa2d00facd77aa8dcb1de29e571f4f45c6ac205b5ee71e52f83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c98e30094e5b04f4e067608e376d7526aa257022db3f416cb37d7bace09569cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2974edc53aab9507c51d3a32341d78d4600cc15509aa0a63b50698cac647aaac"
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
