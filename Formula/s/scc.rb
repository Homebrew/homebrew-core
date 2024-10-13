class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "bdedb6f32d1c3d73ac7e55780021c742bc8ed32f6fb878ee3e419f9acc76bdaa"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066e4ba3a8bdbfee0c55f526b329abc80436d9bdafd7f9a7ba4cc9dacf853aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066e4ba3a8bdbfee0c55f526b329abc80436d9bdafd7f9a7ba4cc9dacf853aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "066e4ba3a8bdbfee0c55f526b329abc80436d9bdafd7f9a7ba4cc9dacf853aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "46dc8b9901b3c5129b8433cef45045c8967999b81bb8e12e67cd6432f520262e"
    sha256 cellar: :any_skip_relocation, ventura:       "46dc8b9901b3c5129b8433cef45045c8967999b81bb8e12e67cd6432f520262e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f65cf401710b86fdad845db3d11ecd288b962eb4525878dde82cbb8929cdce6c"
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
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
