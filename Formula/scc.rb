class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.12.0.tar.gz"
  sha256 "48baba45e76ef02bb23ded3d1d904fed7e19297066a47b7e6b46baadc50c1eb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0c6ea4aa2c4fd242ee9081ab2dfcd9d76d2112eb46c40d59d7b7105d94fa770" => :catalina
    sha256 "9c9fb5690b129a8b6cae194c7480f79cbf0e33942ac9e5e049d57265dd7928ca" => :mojave
    sha256 "e92aaef6efd17c2356a0c82d38b7652279d6743f00495c793f17c66e9e2b8664" => :high_sierra
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
