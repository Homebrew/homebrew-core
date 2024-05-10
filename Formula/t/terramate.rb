class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "378051a4f4fb964d9d4fdcbe0cac3e77ac59cd9d79f2b7c32aa2b3a3c0d12e22"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ae08cb1122459c4bb360714f60635e68f28ab5df5f8f49ad14af94105774d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce91bbcc5c6350ad7b015ed813c4a1f009a3ec3293fabf0c5674e617336f9d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f60978b08f94e4b5bb30ac4984ddb8adfef6ef3201e92fa2160c463b3ae70833"
    sha256 cellar: :any_skip_relocation, sonoma:         "7637252aaa5595534c870fea00fc38824b94747daab6a771f4c63a8960a711c2"
    sha256 cellar: :any_skip_relocation, ventura:        "16d6ed45be1a8b6d8b09a7903d51a0aaa3100375e7dce3c4cc4c89cc3a53ce44"
    sha256 cellar: :any_skip_relocation, monterey:       "720291316f4644a1ee674636a36e98a75c91ec1e9cf85adc79e4b3bdcb27410c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d02bacb8c6699e41e445958f3f1fad748150c69cd53e634dc506bfad7df3818"
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
