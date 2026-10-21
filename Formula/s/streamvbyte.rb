class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://fast-pack.github.io/streamvbyte/"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "b19188f66065553350a716346580188c0c33e40667b006a68ec25cbde6c31bf4"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcf08f07c02a8195fad6f067fc8f6ca07f7ec4296a1ce38cf6281bef99377778"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe8da80633904f934dfb331a161fdc6d46f5522a295dc46c35f16ad66f66c5b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f7972fd9ba9d0f7241dfa326e01b3b31118ebcc78b7f858d9ac7b19db016ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a5bb6020eedf6474f99d38b4ffed2f1d7286795b9a951e403f8e6df492b9eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "45c5f80cb4524410f45ee5a68e21e4793756a11d04f27330d13bf76f0a6a5ae2"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
