class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "028869a7d053879a8e3f2872fdd792f165db13696918d08863475c638f08ef06"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0474b2efe2e1d6f8baa6dd033d193ba62bac2e8cb04428d44fff4f0fa208176a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a60a5efba1a6a1fad46ea821d1530d6e51fd560bcecf8415bed888d5decc8621"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02324fec0834b4c51aea52dab4a3d2f45ebd787f6c339ed5150923e4f047b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "545a10d27482aa7ac0df050b4a371324c04ea29747599302e4c5bfe080fedb44"
    sha256 cellar: :any_skip_relocation, ventura:        "00fd1132812004e0516dccd3ed1184c7be74d5987a82079abe3bedd05a1dae38"
    sha256 cellar: :any_skip_relocation, monterey:       "fd5ade176301cc5dfa6f8267c05f6c0ededad115b971b10696ab10cd57ea14f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2536f34d7049b22d596fb3e6d0d298f930668d2e2e69dfa8a6b327b7f1abe3b6"
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
