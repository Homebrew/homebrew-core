class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/lemire/streamvbyte"
  url "https://github.com/lemire/streamvbyte/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6b1920e9865146ba444cc317aa61cd39cdf760236e354ef7956011a9fe577882"
  license "Apache-2.0"
  head "https://github.com/lemire/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "480fa7236c98cf330ea833acfb5a04bf18eaf65da54721afe9895eb9142e8b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e58906595b65fac184e748a2ccb212eac960b0b7d44cf0883913c0c7545a50da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66f082548db8eb887d605e59486c213a1ed91359a11647774416c5f6cdce022f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531ad325e65fb8183fa2743faa9131199fbed692b8f3965da713c84143f56e0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8f6f45ab02c05cfd3225d2abf6d16c3a196d16d19a7eda10fdff5f25314ba8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cef485e34ac025d004a1a39fc4ef3b0e68ccf19b8e15a0375558eb581717d8b6"
    sha256 cellar: :any_skip_relocation, ventura:        "70102a6cd14a7b1f2062be3f2c92d178f453da8cb04eabcadf490aed767228f4"
    sha256 cellar: :any_skip_relocation, monterey:       "82cf3201eb5bbb93c0ebb0c3abf65b62c2d96751bc94e2a78541e008f4141452"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb9e50d4b5d0707015f35b05058bc46bd4e0fda2d203da1f682a714e1e303a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da1937bdc9548b59aa1d9493828ad1c252c5be113c805896f311de0964256173"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
