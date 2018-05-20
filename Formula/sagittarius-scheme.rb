class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.2.tar.gz"
  sha256 "d20cb780bdcadc12243ef971b0f6a7e92b4d104aeca9fef1447394ba764f8ea7"

  bottle do
    cellar :any
    sha256 "f83dcf59dafca0c18a7ad8c73eb421a6104d48aa08d910f5aa41a6328725ea00" => :high_sierra
    sha256 "75ae6e254f15b4d9c72428f773e5f38173353208d01e0d67ac6290780fdff49d" => :sierra
    sha256 "9fc3fcd75d880d8022c55ec8d7a7f16794826d336bb123fe295094284bfc683c" => :el_capitan
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
