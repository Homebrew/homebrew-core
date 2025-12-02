class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "c0b5d8fac3d126178f7ec197567eb54566f35faa5d6f3f6d3b67c76197a56691"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f1be1d2a7eb9477f196fcfb5ffe0c8024a39a8852ed3958bc97a3fa09e679cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1be1d2a7eb9477f196fcfb5ffe0c8024a39a8852ed3958bc97a3fa09e679cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1be1d2a7eb9477f196fcfb5ffe0c8024a39a8852ed3958bc97a3fa09e679cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3fd1aa69df4461a58bdbd86ff2c8bcd4baf2e4f7e97e2eb172002c17e8408d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332f5e9d7051c1a09123d7132a408d46451a63d2430ee88ce8fd81409d3cc4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98f1e5d2d185559e9f9072fc6e11cbcf29ac4925591b5397ae274662c1d8266f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
