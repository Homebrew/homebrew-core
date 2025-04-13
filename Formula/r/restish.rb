class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/danielgtaylor/restish/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "0aebd5eaf4b34870e40c8b94a0cc84ef65c32fde32eddae48e9529c73a31176d"
  license "MIT"
  head "https://github.com/danielgtaylor/restish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af849ab00700354c245e51554623c3ebff73e73c96d4111b27d91fd63c3a46de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af849ab00700354c245e51554623c3ebff73e73c96d4111b27d91fd63c3a46de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af849ab00700354c245e51554623c3ebff73e73c96d4111b27d91fd63c3a46de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e095d39764cc37c5a7d04ff8f7844fe85ef49872a48d4edb10e8456aa514b47a"
    sha256 cellar: :any_skip_relocation, ventura:       "e095d39764cc37c5a7d04ff8f7844fe85ef49872a48d4edb10e8456aa514b47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a5dc617d1e1861651fba58b970338a23cf9fabbba515d11b4e8a51e8898e9ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"restish", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match "\"foo\": \"bar\"", output
  end
end
