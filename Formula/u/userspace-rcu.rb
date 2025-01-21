class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.0.tar.bz2"
  sha256 "4f2d839af67905ad396d6d53ba5649b66113d90840dcbc89941e0da64bccd38c"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48c80450dcb49256802a0ec7aa2f656063609f5e9947e9e29d7e6762285b7e2d"
    sha256 cellar: :any,                 arm64_sonoma:  "2b9c19f79a0cfbe87e66b0f40e1c6266e3d74ec9d44d175b4c310fee18adf518"
    sha256 cellar: :any,                 arm64_ventura: "8f06964739d90a0a55af30129325d8fc5d495780437d3abee8811301ca6512f4"
    sha256 cellar: :any,                 sonoma:        "d597a5a653226c897a1c104171784243b798522d5652135b1a2ca066cbebb482"
    sha256 cellar: :any,                 ventura:       "d69f603c04036cd652afbfd7dfff65160d5f7726da2321307b21eda275e3c2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914c5c838d6239e7db848b098b66b65271a311d1be1c312d4d40b691e2d336dc"
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
