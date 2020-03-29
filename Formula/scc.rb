class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.12.0.tar.gz"
  sha256 "48baba45e76ef02bb23ded3d1d904fed7e19297066a47b7e6b46baadc50c1eb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "108e239ccf083324267fa3e0afa28c0fa48314b48d1cb419ce6c188d3177de4c" => :catalina
    sha256 "f314664bcaff93ec70bc6bb3e63f1e51a1d4007ad9cf509de823efccdf57e536" => :mojave
    sha256 "7c246db3f85a08e99c6fe3c51224bd95f49dc4a737394c1c4ff002c050c9af24" => :high_sierra
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
