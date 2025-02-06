class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.11.9.tar.gz"
  sha256 "ccc5aa5e09839cdb200beac11debe3e72d868fdc50222917959f028984e5dfa0"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf900074788f17bc498666f390e4286c044cf43c671aa07092c60b3c934482f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf900074788f17bc498666f390e4286c044cf43c671aa07092c60b3c934482f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bf900074788f17bc498666f390e4286c044cf43c671aa07092c60b3c934482f"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ec9ff5c95e37b40e20581144a3efbda4f8dfe32a042a1d8b66f1ee7b7cf2bc"
    sha256 cellar: :any_skip_relocation, ventura:       "87ec9ff5c95e37b40e20581144a3efbda4f8dfe32a042a1d8b66f1ee7b7cf2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed865dcb24588a3b5ed45a6ea17027a2faab131853dbdc39890d555f0347b2f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
