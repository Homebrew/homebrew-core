class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.0.1.tar.gz"
  sha256 "ca02fb81a5763a07ca11150e86b4762c91de05588bf573c1a7151550896f455d"

  bottle do
    cellar :any
    sha256 "8e9a19e387b9f08cc38d3fac73f7cfd34bc62ae5415748afc87443ee0a634d5e" => :high_sierra
    sha256 "9de62f9f0364afdc741ebea1af3fd82b1a2414f3f01235b9fa62d2106b49bb6e" => :sierra
    sha256 "85cf1b76c1108c08469d2d695b8bef6f2c2bfda4125553d251c1fd26042f4c9f" => :el_capitan
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
