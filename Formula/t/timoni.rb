class Timoni < Formula
  desc "Package manager for Kubernetes, powered by CUE and inspired by Helm"
  homepage "https://timoni.sh/"
  url "https://github.com/stefanprodan/timoni/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "00df18a0ba3fe3f738d9eb54f9ddf946599b1e3b06f771e96bdafac443ed573a"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/timoni.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d6cf45579afce7baa5e006d138ad747e4ad945e8f004d4ace454aa3a21b92a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee448ea191c171fb9003e78d5f510c4116a61a3f5e745ba6c13bc46d426395df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d84842b0a7c7121f8e36cae3adf24134e3ab7a68837493aa42b7bbaaf68a33f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bca92fb01ace26b451f5683abd7753b69843d7651090652fcfcb5d475d182aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7d9175583753dab8b44ca9e603a35f1424f3cf92a06037c7a9481853c111f5f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84c79eba9864799a0f70a63dd7cf1e46b17a0dce86895c3ebc6250af2b4e5f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18433c77c8a6abfa2a6035c44ca58738ae70ea3cefbbc2361b5b4bb2a364405"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/timoni"

    generate_completions_from_executable(bin/"timoni", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timoni version")

    system bin/"timoni", "mod", "init", "test-mod", "--namespace", "test"
    assert_path_exists testpath/"test-mod/timoni.cue"
    assert_path_exists testpath/"test-mod/values.cue"

    output = shell_output("#{bin}/timoni mod vet test-mod 2>&1")
    assert_match "INF timoni.sh/test-mod valid module", output
  end
end
