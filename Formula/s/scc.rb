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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb86cdc318f3370a0f47db951546e7684b214afc3523c3a261d99ae9eec8f2bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb86cdc318f3370a0f47db951546e7684b214afc3523c3a261d99ae9eec8f2bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb86cdc318f3370a0f47db951546e7684b214afc3523c3a261d99ae9eec8f2bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "894648811fb90e07ddbf2a52fd9f8674bcd16e5030e91995c77712374b2305a3"
    sha256 cellar: :any_skip_relocation, ventura:       "894648811fb90e07ddbf2a52fd9f8674bcd16e5030e91995c77712374b2305a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817d422921d1f0c9c1ddcea9f7f587f276b353a9e8c3f1ef1bcd38df312ac0eb"
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
