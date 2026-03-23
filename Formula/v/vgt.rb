class Vgt < Formula
  desc "Visualising Go Tests"
  homepage "https://github.com/roblaszczak/vgt"
  url "https://github.com/roblaszczak/vgt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c442980c2205d45d527205fc9f832f4d27f4d3e8c815f471f428266f6fcf33c6"
  license "MIT"
  head "https://github.com/roblaszczak/vgt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63d6f3c39929c640180bcb93c791bf3e4cf0dd107665b6f4e1170a2843ee534c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d6f3c39929c640180bcb93c791bf3e4cf0dd107665b6f4e1170a2843ee534c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63d6f3c39929c640180bcb93c791bf3e4cf0dd107665b6f4e1170a2843ee534c"
    sha256 cellar: :any_skip_relocation, sonoma:        "daf148a393cc7ac3d406ea5a69c492488ce90140fa5e173bed78d5ef5e8a7481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b604af5e02e05c26624ed38460239b52a5966a6239ef6ec5cc3ad77bc345c8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a39e082f0bc051f17055fee8ee84ee4bbca825046f33d261d39873e9d57867"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.go").write <<~EOS
      package test

      import "testing"

      func TestExample(t *testing.T) {
        t.Log("Hello from sample test")
      }
    EOS

    output = pipe_output("#{bin}/vgt --print-html", "go test -json #{testpath}/sample_test.go", 0)
    assert_match "Test Results (0s 0 passed, 0 failed)", output
  end
end
