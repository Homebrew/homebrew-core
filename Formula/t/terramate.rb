class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "97104f5559ff054dd47c6d00811c1c0f98d768a2ed563356a76ea45bbd4cf556"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1413c15cfeb837334acda7b1c31c32d26311e38b7160f51723e1747a317df6ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1413c15cfeb837334acda7b1c31c32d26311e38b7160f51723e1747a317df6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1413c15cfeb837334acda7b1c31c32d26311e38b7160f51723e1747a317df6ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "c539fa1c9d9491de52e895a6e26ba3f699bee61529e88708692c7a0964c34fc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f35cdbc69afc13fcc2b32fe0e5ebdd4d01fa238e6ce07583dbc8105aeb225be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7700b0db3c51c344a70f48a080cf006ae842a750e0c1bd945f0c70bf0e5908dd"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
