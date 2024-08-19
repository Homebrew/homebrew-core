class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "74b831e3b7931322c059b6a2b5b9e71522c9fe546b6727f01c96b14440d566b6"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "754c4bff0e6c5bf2c41606d17d0ecdf0c623bf1a9b02aaf4257f4339e10468f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff482aada7d0c39d2e16815e9a1f161e8092398bb403ce15717b776779e1285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d255c4e2a2ff6106bc15bbc6f466466f5a96b6e7fab7440edbdafd657c4c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d29a448c91dc23f1d38618bf4523a67a35aea34c711527265228586ef281997"
    sha256 cellar: :any_skip_relocation, ventura:        "d0589e872f385862a49314a5eecf27789f15f1ded4f1308ff83fd281fadcbaf9"
    sha256 cellar: :any_skip_relocation, monterey:       "866191c7063bdff700aa154663b3e1fea5825f754821ed3625ad75ffe10be3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26eec0bb22f81dee8fca663323a271caecda8494e484247d916afd5fa135850c"
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
