class Simdutf < Formula
  desc "Unicode conversion routines, fast"
  homepage "https://simdutf.github.io/simdutf/"
  url "https://github.com/simdutf/simdutf/archive/refs/tags/v7.4.0.tar.gz"
  sha256 "8fd729ebfd5ec56cb0395bcc176c4801e1f8a0ea834d166d52279d7b9e801283"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/simdutf/simdutf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb8161f0c3bd6dd9deb0770ff3a49101c89fcfd113f092dadff0ac6fb0c4af2d"
    sha256 cellar: :any,                 arm64_sequoia: "1b009aa16671a4895fc41e373b24a4d2caee80427caf178209a631c1341e9161"
    sha256 cellar: :any,                 arm64_sonoma:  "6a1aa7199d23529c22da6a71912dcd39c03bfecb983e7a7a8b9e737281bb3e98"
    sha256 cellar: :any,                 arm64_ventura: "9966ecbc52b8d2dc3be7eabadcd0db28be035651681bd1f351f72ccbcd3c9ed2"
    sha256 cellar: :any,                 sonoma:        "0ee159df569e9f5ce6bb19d57248c79fe47e85541909a156531e3c148da2e458"
    sha256 cellar: :any,                 ventura:       "df9e32ea261a0065aebe87137650da74975e672c4c5a1687cbf9ded6cbc7bd89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a92fa8de691b2b306b2caef9e0e4fbf0c3f93ecc826b303ff519b368ccc514b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b2f496997bddbc620314df98ad29b3863b570d626f9f5a279a99acbcafe38f5"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"

  uses_from_macos "python" => :build

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/simdutf/simdutf/v$VERSION/benchmarks/base64/CMakeLists.txt | grep -C 1 'VERSION'
  resource "base64" do
    url "https://github.com/aklomp/base64/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "723a0f9f4cf44cf79e97bcc315ec8f85e52eb104c8882942c3f2fba95acc080d"
  end

  def install
    (buildpath/"base64").install resource("base64")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
      -DFETCHCONTENT_SOURCE_DIR_BASE64=#{buildpath}/base64
      -DPython3_EXECUTABLE=#{which("python3")}
      -DSIMDUTF_BENCHMARKS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install "build/benchmarks/benchmark" => "sutf-benchmark"
  end

  test do
    system bin/"sutf-benchmark", "--random-utf8", "10240", "-I", "100"
  end
end
