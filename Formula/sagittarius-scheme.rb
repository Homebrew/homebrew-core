class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.6.tar.gz"
  sha256 "b946b168fca70f84d922bcfa2125e2e64ad5fb8cf67e4204deb43dd2dcdedb0e"

  bottle do
    cellar :any
    sha256 "a361faf84c92724338658d2bfe40ae6a35e9654628bb2386e83d1cbf13f4ede8" => :catalina
    sha256 "e260d068e0494dfc4a6e02bdf24731fe1c8b0d6391958413a276a38d81a9bf01" => :mojave
    sha256 "1b1890495faa84c7e3d7fb8aa664963a46efa14f70adbe3fdb1c36b114e91b59" => :high_sierra
    sha256 "a2c30e62b8ed18be2db099222966f71efbb54eed1e901716df76edd3d4edd8a2" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
