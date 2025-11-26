class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/rest-sh/restish/archive/refs/tags/v0.21.0-cifix.tar.gz"
  version "0.21.0-cifix"
  sha256 "5cf2750f1db524591d8748bf4c03796d7b1a688dd119892a6e5d1764cefe5847"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33614081c80256bdf3acb116d3f257c6489cd787e2ff9df3c74885894096c37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8aa4ddbae64dffa735470d8981074ea73c0d12c1f2029fcfc9e734a9f348ea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3d2dca304c360b00dbb8e93605b7655fbaa2dc3654e9ff1f069ed63bd1f08e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b22e5d04d229446fd76949b5683c18185ee979aa8285db31e2de5693e8a9d8fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34179ef97dd275569cac439f24bbfaedfbbf8e087b6cfc7e9d76caf7a3cf75b"
    sha256 cellar: :any_skip_relocation, ventura:       "1eadc3f54a712bdd3eaef9d6c3b709dcd6e3952e115a7014cef918fc15b192fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da1c6f1f5713e62b76b0c15cbeb0a694dd61be0a2a79c5d5a94d2ffe39fdf18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677209c2e2a6883004bfbb59a807e2206dd4bf5997715fbd7ae98decf24dcd72"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for crypto11)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
