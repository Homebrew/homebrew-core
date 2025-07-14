class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "7aff5be7c491400cad750f0d6d0c0a8d113b1ebe28dbe4fc75858cf682530b00"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690c3435abc0bc5b01ee49bff5f1990e7932e62d5bff2ad2fb2b1343866b9eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "690c3435abc0bc5b01ee49bff5f1990e7932e62d5bff2ad2fb2b1343866b9eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "690c3435abc0bc5b01ee49bff5f1990e7932e62d5bff2ad2fb2b1343866b9eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "299e19291220eeed2baad0fac019d473c0c60a3a9731474ebc6a76daa3669377"
    sha256 cellar: :any_skip_relocation, ventura:       "299e19291220eeed2baad0fac019d473c0c60a3a9731474ebc6a76daa3669377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26ebd91f5b34cc55eb3e9e6f9f1da6b41cfa30db9f437fe003765662080e1198"
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
