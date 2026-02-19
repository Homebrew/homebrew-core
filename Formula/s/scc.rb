class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "15e09f446ee44f3ebdb59f55933128256588d0343988692f1064b9bfb4f96dd7"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38026b19d85ac58395d2f860175c87189b78cfadc9edad78056d73af87fb728c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38026b19d85ac58395d2f860175c87189b78cfadc9edad78056d73af87fb728c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38026b19d85ac58395d2f860175c87189b78cfadc9edad78056d73af87fb728c"
    sha256 cellar: :any_skip_relocation, sonoma:        "859f6d6025ca99da9ea268bb1e31a6391e565e689fbeafb0bbbbdbe3b91fd5e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff61384425a01701818b616f52dab8c565367e48d27dffb6c83b1b4a59e0d15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1c92076f15efbc15253b0934ad74c5f7dce9d83ea3e800bba55ac97f238764"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scc --version")

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
