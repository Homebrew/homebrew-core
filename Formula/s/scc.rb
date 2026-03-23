class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "447233f70ebcc24f1dafb27b093afdd17d3a1d662de96e8226130c5308b02d01"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0e2990323b5fc911cc49cb1e76825d0d40dec63d6dd3005ca365661d54f91b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e2990323b5fc911cc49cb1e76825d0d40dec63d6dd3005ca365661d54f91b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0e2990323b5fc911cc49cb1e76825d0d40dec63d6dd3005ca365661d54f91b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d01d294651add28aac7cfd22bb92eb8a2d51a1391f86e1d1983b75f53a350f70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982eab81bcfff356c30a69eebcb48b92dde737b2dd391a14ecc444688da246a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1abde78079b9778eb24f26998b8857d001ad357c9219629993cc833a817f32"
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
