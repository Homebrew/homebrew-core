class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "4f3cf36010c542b10d5582afb91c668b26889160b184deee21b4319347030a7c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/scc.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74e37c3265026b9cbe198cc876d592b94a59636ad22ebcc5a83935cbf6826d3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74e37c3265026b9cbe198cc876d592b94a59636ad22ebcc5a83935cbf6826d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74e37c3265026b9cbe198cc876d592b94a59636ad22ebcc5a83935cbf6826d3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "74e37c3265026b9cbe198cc876d592b94a59636ad22ebcc5a83935cbf6826d3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "19a4f2048124c8b2f493e96738a9795c17f31d9d94ccf61894c768e6e52efde3"
    sha256 cellar: :any,                 x86_64_linux:      "256fd514180a491c9d415b665dc21de9d0f026efdab2f582e56662224866997d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
