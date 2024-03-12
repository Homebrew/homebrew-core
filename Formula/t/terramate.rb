class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "3e48cf1399fcebedf271f9430760fe5609c7d0cf719e4fdc3505bd48fd038acc"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c9a97176eb6f148935da00597b62d5993366a31c5178680af84816ad878c8fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6a823c0f4bcb87c0b2f86643bfee28af560ab1d5da7e52a1668bd40d195b8f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78304a586af68db585efaf4b5df36bfb929bddd0e804046600d3221ef910cf74"
    sha256 cellar: :any_skip_relocation, sonoma:         "840fad8fc309205b831a15cb99bdababb8cb8b46adc8a51a89f82e08e86cce0d"
    sha256 cellar: :any_skip_relocation, ventura:        "6da61f723c2cf02f68eb494219ebaffdb6148c06a259e71d487daf9f2e0f87fb"
    sha256 cellar: :any_skip_relocation, monterey:       "057f4827376c3cd2e907c432f98cef7b7b4d814eb03521dd90356a4274c40844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69eb01a7d80ee1d2a24bd7d2bd0a6904c72dbb4c04db17d3237072da9a2c71b"
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
