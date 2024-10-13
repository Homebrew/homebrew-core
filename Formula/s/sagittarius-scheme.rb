class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.12.tar.gz"
  sha256 "c3a690902effbca3bc7b1bc3a6c4ac2f22d7ae6e0548a87c5d818982c784208d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e376a30fdc05b7ca8951ab2e40faf83187dd63022ecd6a6530097b3a65e10ae9"
    sha256 cellar: :any,                 arm64_sonoma:   "7c07c019c9d52cd1d90fa68930ab2e430dfa58105a44a834b6c3a919cee1436a"
    sha256 cellar: :any,                 arm64_ventura:  "397c59a96c5bc10879d42a480c3df89e829d4ff17649edf43e186b1ab10d3e80"
    sha256 cellar: :any,                 arm64_monterey: "3e7bbd920bb306791edfebd38a67635d77e1c7cd28de1b01399b72a8a7edab01"
    sha256 cellar: :any,                 sonoma:         "62ba73625484cf31ad62454ec7a22a2cbf54af63f691ba9c189f40946d25f4e1"
    sha256 cellar: :any,                 ventura:        "4d4dd3362acca07325ecafd6cca5322df228a1f17d07405552a0406aead1612f"
    sha256 cellar: :any,                 monterey:       "fa85cf9521b177a44be8122f0749aa6f00cf1ed73294f7b164a68c95a47d930b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a45f44a21b16794aff703c0dc82af965f70c3009ce3159165cd6f7d04302d40"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

  def install
    # Work around build error on Apple Silicon by forcing little endian.
    # src/sagittarius/private/sagittariusdefs.h:200:3: error: Failed to detect endian
    ENV.append_to_cflags "-D_LITTLE_ENDIAN" if OS.mac? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", "-DODBC_LIBRARIES=odbc", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
