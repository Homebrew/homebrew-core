class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "997ecf9b96c5f828628488abd96a6cf3c756d1045d9223906bc553d6357c0907"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3ad5eff5eeb4098a06cba1b02ffa2d227d2e4eba2d0f3c61996c819777acad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ff5b16769986e4583b6d24a364ef81543e60af9b9bc9f73c36f1ef5137a732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2aa3a5151601ad0c6290c5a96901a89f20519cc49656f4c00fc2bd6280ee85"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ed01d567fd259f2b10da74d71440dfa8eb759b900971b5db4c1c5d483ecde8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8aaa132e6addbd26634582efe76a40607109ef78ffa571b24e1973722e41a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4b7707e848e66b8972db3b58452a1a4de30b699b89c44638b86e7fa620f421"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
