class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.10.0.tar.gz"
  sha256 "cee0682bf8151964af534fdac07734595da9b264dc1119fa689d8fa2524bd708"

  bottle do
    cellar :any_skip_relocation
    sha256 "c401d3ab6b113cb7b0e494f86b333db612df1bae626522735d901a17c8ae83df" => :catalina
    sha256 "41610eca331399d5ba16250eb51e3f577d60bcef97d1db25680f69f3310401cc" => :mojave
    sha256 "d5ca245c4bd9a6aa7eacae5a52a2236807eb95e65192d8a1848fdee055130399" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/boyter/scc/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/scc", "-v", "github.com/boyter/scc/"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "C,test.c,test.c,4,4,0,0,0\n", shell_output("#{bin}/scc -fcsv test.c")
  end
end
