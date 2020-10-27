class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.7.tar.gz"
  sha256 "a8517ef342aadf9fb964e03fd03d4eb13287e5686406ba60d93d6e5c9c91f2a2"
  license "BSD-2-Clause"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "7199d76824cd0de62da70f2eff3db66f0944c2851e4ee868359b7bdbe4685994" => :catalina
    sha256 "d350853fda37321efe29a14f988b3039126559e489b2fb93a41ca538ca7a2f29" => :mojave
    sha256 "8824ccf2baa439cc953d8b373010e5f00fabb51dd6837f68323993b69549bb84" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    system "cmake", ".", *std_cmake_args, "-DODBC_LIBRARIES=odbc"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
