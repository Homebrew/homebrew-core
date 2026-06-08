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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6770468fcdb16a8f1fcae82285026a84eadd5524fef199c6f56a7213ee195239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6770468fcdb16a8f1fcae82285026a84eadd5524fef199c6f56a7213ee195239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6770468fcdb16a8f1fcae82285026a84eadd5524fef199c6f56a7213ee195239"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a1ad7fa233caf6383633e0180fc9c80b468abe1fb55af63ddbe0fca153efd4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0d003227e2164092960ac21ddfe9b4429bf8afa04c49f5f65f06689a8e5d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1ed3b5514ca73c3783e66ce81d563c860ef46585dbdac0a9f7d8c805c4c823"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes,Files,ULOC
      C,4,4,0,0,0,50,1,0
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
