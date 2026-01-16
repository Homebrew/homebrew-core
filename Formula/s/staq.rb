class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/refs/tags/v3.5.tar.gz"
  sha256 "838402b6ca541200740cc3ab989b3026f3b001ebf3e1ce7d89ae7f09a0e33195"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "1518fdd5369e20863afefa4158c78b87fc4f01cf09967623a2b1af8225499790"
    sha256 cellar: :any,                 arm64_sequoia: "8081f841203e64e3423fb6305558c1a538b86fdcbbd2e13d02944ea36dfa9ae9"
    sha256 cellar: :any,                 arm64_sonoma:  "716a1214491fac80364ace9c88950c123f669912fd76dd950504c60780ddeac5"
    sha256 cellar: :any,                 sonoma:        "6b589aefacd45146637ecf6f4b39d69fd1e32aec9f2f60c0da80776cac60dc28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0ea0b4548a55c3c72c3f33761cc9bf58e460b84db244b951eb586b0c2b77d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16a8a25583b15bc7384c346ea277598642e637f19b36ebbab73dcd48e3dfb1b"
  end

  depends_on "cmake" => :build
  depends_on "gmp"

  # Backport fix to error: no member named 'row' in 'col_vec2_t<T>'
  # Issue ref: https://github.com/softwareQinc/staq/issues/85
  patch do
    url "https://github.com/softwareQinc/staq/commit/4ac5dcd13ae46dd629ee938602452a5c8ec0b7c0.patch?full_index=1"
    sha256 "c71447c1fd065e8818894965219e0fad652c3a8649be645296d4bc9ca5a9d656"
  end

  # Backport newer bundled fmt
  patch do
    url "https://github.com/softwareQinc/staq/commit/6847ebed2d167a0f1aa476cfb1d2b62b54fde6f9.patch?full_index=1"
    sha256 "acdcdd7afd9650425f1659b0b3b0e601c27e368d3722385416dcc5ee145528f1"
  end

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
