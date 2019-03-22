class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.8.3.tar.gz"
  sha256 "04b0aa78108addcdeef64a4333ac75dff2833b7a48797b7c9060e325520db706"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "df79931139f2fe9ad9714c4304b9c2c5d3322b53d7e187f6118fa709097f7f00" => :mojave
    sha256 "d851b6a0987ac11b3ff5a6ede8b88bfa9e09251ef1fdd76237ad7e9910688242" => :high_sierra
    sha256 "13d67e18b133621ddb49ddc5b34caff453aec85d95607d2ab83f03cdf0c79b76" => :sierra
    sha256 "f42c0d8e15ddcd2212235b4954e8ce0896e8f3fc1f07c388cfcf49dca96888f3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :osxfuse

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
