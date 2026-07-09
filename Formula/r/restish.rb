class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/rest-sh/restish/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b80dfebc06288d8ce6ca1e83fb1b848e345958001d878220b9fa17ae702a7dc5"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f4c7976ab83ce80da6e823f11c8f4a714b9aaee7589fa95fe0b50580e96e4e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4c7976ab83ce80da6e823f11c8f4a714b9aaee7589fa95fe0b50580e96e4e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f4c7976ab83ce80da6e823f11c8f4a714b9aaee7589fa95fe0b50580e96e4e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6501fb56129d377844177e6933545b9469185022f0653cfdc1ca456f4c87fe68"
    sha256 cellar: :any,                 arm64_linux:   "068d081a8e65df9649d5ab21227f223553083bfad644d70120861c4b8706d41c"
    sha256 cellar: :any,                 x86_64_linux:  "929190e02479fb8c436c252af4ec4f58e47f4dc4d8814efd2762af5bf4432eaa"
  end

  depends_on "go" => :build

  def install
    # Workaround to avoid patchelf corruption when cgo is required (for crypto11)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = "-s -w -X github.com/rest-sh/restish/v2/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/restish"

    generate_completions_from_executable(bin/"restish", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match '"foo": "bar"', output
  end
end
