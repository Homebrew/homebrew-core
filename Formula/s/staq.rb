class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/refs/tags/v3.5.tar.gz"
  sha256 "838402b6ca541200740cc3ab989b3026f3b001ebf3e1ce7d89ae7f09a0e33195"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4a78fb5391ce391ef6df17138cd12b2cdb940b6826ad87f31ae4c28e879d1f87"
    sha256 cellar: :any,                 arm64_sonoma:  "ab344e9a41f34a721802904a1f216f9e386c7b4b90036f5058a1d62d5c969ced"
    sha256 cellar: :any,                 arm64_ventura: "64702f48420ef83e1d3d6286b332a785db0cc0860ae9d1ba553171155df563bf"
    sha256 cellar: :any,                 sonoma:        "0e2d26ec6e834188613c7c9005c871922ecc6b5e9c92c9da7195b3121f663df3"
    sha256 cellar: :any,                 ventura:       "ba4e7fab6b78e93d8fe4bec9dac21bff7cb88f33101d6d69cf17f8671677a42f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08f0668b5db8f44564286e09223ec36f40dce62d3182e09833a0237ed865885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b7917bca6fd1e92003d7fd4fd308eae7d764f65eecb6cd8a8c41e0a1bfe9f7"
  end

  depends_on "cmake" => :build
  depends_on "gmp"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DINSTALL_SOURCES=ON",
                    "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=/dev/null", # skip unused FetchContent
                    "-DPython3_EXECUTABLE=/dev/null", # skip macOS /usr/bin/python3
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.qasm").write <<~QASM
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      h q[0];
      h q[0];
      measure q->c;
    QASM
    assert_equal <<~QASM, shell_output("#{bin}/staq -O3 ./input.qasm").chomp
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      measure q[0] -> c[0];
    QASM
  end
end
