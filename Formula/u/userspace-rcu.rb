class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.3.tar.bz2"
  sha256 "26687ec84e3e114759454c884a08abeaf79dec09b041895ddf4c45ec150acb6d"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "803c04e96ef85190c9338f6b91411f1645b89c5bd8de5a1ee9724f2a7e4ccbd2"
    sha256 cellar: :any,                 arm64_sonoma:  "e6df3658e9fd7684a6b9d5cd14941712e84f9ed881f7388b4238fe6a3f0e9afd"
    sha256 cellar: :any,                 arm64_ventura: "b2efd6e63f3925c486bf181900733d11fbe0efe9134eb5f9c1b5fd0b57915dfb"
    sha256 cellar: :any,                 sonoma:        "295eca2ee55330fe9bb24779117146c560c01682a2cf3502a9b82b6579debb3f"
    sha256 cellar: :any,                 ventura:       "0611a1a66d68b403c40341b4505937dbd305d448caf46720314d7a8fbb952ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab9a83c005211672492d9524dd791315c90a2f57b6f05f98fbd637036b5c22f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd83d743bebf1d0bb809fc70f305bbc175738a680b1c998b317895785ca0f50"
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
