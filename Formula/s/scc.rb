class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "161f5d9bb359c6440114b7d2e0f98d588c02aa66fbe474d7660b244687fefb70"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5d63f13bfd23c3d3bf87ca06bc7672b30ef4a7a1bae4de2da433c9237e10ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc5d63f13bfd23c3d3bf87ca06bc7672b30ef4a7a1bae4de2da433c9237e10ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc5d63f13bfd23c3d3bf87ca06bc7672b30ef4a7a1bae4de2da433c9237e10ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a0cb9eb296f0cfbcf651530d8ab7140e71c75d839c79ce58617a0ca1f19eed3"
    sha256 cellar: :any_skip_relocation, ventura:       "2a0cb9eb296f0cfbcf651530d8ab7140e71c75d839c79ce58617a0ca1f19eed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db851bce3a3f786f412d9cfbc7665d4ab8a80d778f5490700601187a81a0b4c"
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
