class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "9d11398455443b8dc90ef2ec8f1038b01913a3f699b60b78e39091403173b8ab"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88aa022a372fe16b3ec437059b16a6e027c680f59c204d9acffaea3ff24ab42f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88aa022a372fe16b3ec437059b16a6e027c680f59c204d9acffaea3ff24ab42f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88aa022a372fe16b3ec437059b16a6e027c680f59c204d9acffaea3ff24ab42f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad16b80919a48847eebd1c443c50611727b468b2342685f7a5e4330f4cef6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b01c2dc1b0bbdea6fc2ca52ae8df006fceaa1153421f031f41cbd4cc5d2899f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
