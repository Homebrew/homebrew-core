class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "69cce0b57e66c736169bd07943cdbe70891bc2ff3ada1f4482acbd1335adbfad"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c106309be70f4da81a92e57a84828dc750369ea042de62c0d22b55f8234c6f78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1089374084f6a2245aba5df39c54eb68b18b12435506b06f0dc0a36a484e1b26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a243dfa656b0dccb46ca9771ffacd25b4b167ade675fe968ddc936e8d45fd96e"
    sha256 cellar: :any_skip_relocation, sonoma:         "68113533c4d0576d5f129d49c786d4cbad5757d03e04c49b41d0d330fd1f7fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "92573b25dd9d58c536e666c49abd90fa30a56c33b0459507d19c2416fb864ee9"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab2c14a6d579e83133a41ba4d87c5d3da61626cb80c65b651c864bb7f4df6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b009f2778884fdcddf3301476b0b4299a339116fb916aea20bcbcf3e814e0542"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes
      C,4,4,0,0,0,50
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
