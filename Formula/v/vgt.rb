class Vgt < Formula
  desc "Visualising Go Tests"
  homepage "https://github.com/roblaszczak/vgt"
  url "https://github.com/roblaszczak/vgt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1db7e7d9c2e2d0b4c5c6f33a71b4e13142a20319238f7d47166fea68919488c5"
  license "MIT"
  head "https://github.com/roblaszczak/vgt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c4a235266ef75ac8e4b1acd2ae26efb5c917066ae58f4c5e9d44f07bf364105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7d4427dfe87372d187344ca5f584db793edcba6c21a64161ad1a7e19e3b723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7d4427dfe87372d187344ca5f584db793edcba6c21a64161ad1a7e19e3b723"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b7d4427dfe87372d187344ca5f584db793edcba6c21a64161ad1a7e19e3b723"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a8a56c5cbb80908ba244db470a0cc708ca661d241c8867a3648d70d33a83ca"
    sha256 cellar: :any_skip_relocation, ventura:       "d2a8a56c5cbb80908ba244db470a0cc708ca661d241c8867a3648d70d33a83ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d6c7512e21ba8d1b393b0090881f7839dd6362c93f26a6649b8eeb860c17c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7fb72f52e24e0095a704bccbbb3aed40ba98aa3edc34eaf37e220bad3ab481"
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
