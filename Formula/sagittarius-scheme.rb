class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.2.tar.gz"
  sha256 "d20cb780bdcadc12243ef971b0f6a7e92b4d104aeca9fef1447394ba764f8ea7"

  bottle do
    cellar :any
    sha256 "3ad910f8a6241c32c024612d529316e21a458436df9667c463d8b25a1fe04771" => :high_sierra
    sha256 "d68a2e83495b0cc018eb13b3ae8a5def5708750c75b4d0f842bd9da3d97fdeb1" => :sierra
    sha256 "97b67492a6ca6adca0d10a4790bbe1118dd9a578522c9271b2bb3415e7ff0e4c" => :el_capitan
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
