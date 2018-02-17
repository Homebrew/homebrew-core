class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.0.tar.gz"
  sha256 "329afa68f1ad95466697c94a41c236840cdc4afc1720e1d4438dceadc298689b"

  bottle do
    cellar :any
    sha256 "a7a531aeb202a2dcba74bc04250ff0b7635eef5f41e65e69f4063dc7a4a7b139" => :high_sierra
    sha256 "0fe1f11fdf6f149cb5cd9ba39d27a9f26fcce0bfd4226eec081c9d8f7d00cc82" => :sierra
    sha256 "e2a7ad03b3100e50829fb6e6f26da1badc40940d4bc6358827cc9dcf1317dea0" => :el_capitan
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
