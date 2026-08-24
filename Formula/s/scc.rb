class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7e0418d7b6dfa881b2673e50d32da81e9abc34475a305b612b57600d85801abc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/scc.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d0a4b693471ba2ac7cf05db3c2f18f23068a1be920867515316b566d879b878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0a4b693471ba2ac7cf05db3c2f18f23068a1be920867515316b566d879b878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0a4b693471ba2ac7cf05db3c2f18f23068a1be920867515316b566d879b878"
    sha256 cellar: :any_skip_relocation, sonoma:        "22fc145899c08fb4c00b813a22be31f0651c9b7edc7c7549ff694d4b184cea23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aa8ffaf03c8337e7af85469a76071a529c7c5a33f32e32263c5264c728b6092"
    sha256 cellar: :any,                 x86_64_linux:  "2d002dcbc361112b99a11c8b19c2339531ba900235e4d01b0af90277818d242b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"scc", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scc --version")

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    expected_output = <<~CSV
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    CSV

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
