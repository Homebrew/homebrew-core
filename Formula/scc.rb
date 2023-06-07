class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v3.1.0.tar.gz"
  sha256 "bffea99c7f178bc48bfba3c64397d53a20a751dfc78221d347aabdce3422fd20"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e799f0018b65a9294d964bcc59ef84cc77e24d111e9009061fe97bb9b63204b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0673820371df7a7e07e4990324b483cf2457e55cb235b3d0137be51c89d90f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "552d9eab337b742208a1ce8d66d502d33221336ad909d0ecb41ed1d69c0f3a9f"
    sha256 cellar: :any_skip_relocation, ventura:        "b01ea7538c30a19861c26d6a78e7739cff2c71ce221c848b03030d710c63b70f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb7b61c5a9d671a0de9716bc4b887ba926a19580772cce384c8c96713e220012"
    sha256 cellar: :any_skip_relocation, big_sur:        "36876856ba28b5a555f15071da17f64336891f856c879be49812b22d0d18594e"
    sha256 cellar: :any_skip_relocation, catalina:       "afac05ed759796401196977828e378b9f12d6709610c1a508570c2668f6c492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8528a5c7e12c1a512f43f0c3afeeec0b5f878812ea4c3c52224cee5911f98c32"
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
