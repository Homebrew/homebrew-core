class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "3e48cf1399fcebedf271f9430760fe5609c7d0cf719e4fdc3505bd48fd038acc"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfc51987360eb999459d55e36f38b2817fe6e189bb147ca77dc1fce58648b229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b84177233cbc9b623f09e08a35d12f97355e60577c8c5e0317aa050971eb9ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2436846201eb8ae22f6bf4eb70f81909de29b255d6552639c7e50cc4941aa88c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a85937d2feacff699723a7b84a8825bd224738dd4956f0de7ec51df42fac2e8"
    sha256 cellar: :any_skip_relocation, ventura:        "24891d776705c250d9c8b283c1cb8f14d9ee0d02253951341db95d9e7c9b19b9"
    sha256 cellar: :any_skip_relocation, monterey:       "bc18e99b1fbba63289c54aaa24c381e0a6523f0ea8d88eb40b85288172995140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999347db1b3ef5f5339b630b819eec4457575ec407dee8ac5aea65efbac4cfb6"
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
