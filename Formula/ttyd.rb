class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.4.4.tar.gz"
  sha256 "b910a33ddaa474c369991ba345187a8a2f4aa420389083671ba3a6c305a491d6"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "63ff5fd136e1ee8abdb01958a7225e166a01b679ef379b848061e9904e4c8234" => :mojave
    sha256 "63870bbeb2aff93c52a8c119de713fe06b13a3acecb637317f8cbb8fd2082ab2" => :high_sierra
    sha256 "85453c4bedbd3a22303021360b43b0e4c9aca637ded605dfa8b29897e2b3ccf9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
