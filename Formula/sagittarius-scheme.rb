class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.0.1.tar.gz"
  sha256 "ca02fb81a5763a07ca11150e86b4762c91de05588bf573c1a7151550896f455d"

  bottle do
    cellar :any
    sha256 "d23d2fab580ed0397c1ca1ba1a8c04984bbd9f106bd4a070c8ff20581f79221e" => :high_sierra
    sha256 "51725d8c867aa2e2b08e1788035293f9494563ddb4cdaced836a696991a3ae8b" => :sierra
    sha256 "adb7d7fde53cf6e332d40cb82dc1f93badb283971cc01e7fc826b1e1f612b035" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
