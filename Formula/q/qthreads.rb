class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://www.sandia.gov/qthreads/"
  url "https://github.com/sandialabs/qthreads/archive/refs/tags/1.22.tar.gz"
  sha256 "76804e730145ee26f661c0fbe3f773f2886d96cb8a72ea79666f7714403d48ad"
  license "BSD-3-Clause"
  head "https://github.com/sandialabs/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eaac263c06614347b5a22262ca2d655171ef4270f70078167ccfa6808b32b5e2"
    sha256 cellar: :any,                 arm64_sequoia: "1188df7c2c0b888e42e8958aab67b0aa563f3e4579281053d8a9b7635f6693d1"
    sha256 cellar: :any,                 arm64_sonoma:  "2b17730f29d4c8e5c35c9293799261e1f6003ff1f27e1c24f5cf5fb26f89df5c"
    sha256 cellar: :any,                 arm64_ventura: "fc5d929394203a698cfdafb7172344f68f0e86eedb6df2a2619b30011bb352bd"
    sha256 cellar: :any,                 sonoma:        "65aaf051110cc87ff81dfa3bcbc53c0f50fb94ecc6247328e6bd1be026317f1f"
    sha256 cellar: :any,                 ventura:       "3670129186200d05bd096d1a7f58374cf346bc8d23245cb583c2f385e0e1ea7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d861e9b0e27ab4312c6ca2b6836c040a13e77ef5e7222f05c4530809afcb4ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feae8cb66d7a8c8258f4da08523a1c94da25a89ef4d645b5cd14d35b8d3c2190"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
