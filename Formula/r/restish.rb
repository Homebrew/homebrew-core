class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/rest-sh/restish/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "059764fccaf8acd366184b10c88a7f0ee0ba0123c196328f156e3286811b3ec3"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818a1f03b9bdc8934b5b7f6c51e1d0cfe617a10abb6386e7090a8b3292b0d368"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818a1f03b9bdc8934b5b7f6c51e1d0cfe617a10abb6386e7090a8b3292b0d368"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "818a1f03b9bdc8934b5b7f6c51e1d0cfe617a10abb6386e7090a8b3292b0d368"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e94a42c9797128c3e3bd528213c7585d4edcba75f050c50765ff0e3d31749b"
    sha256 cellar: :any,                 arm64_linux:   "33ab763f93415f20d2c56af75d4766fd9ae22d01983cdfb5c124c78f3b458450"
    sha256 cellar: :any,                 x86_64_linux:  "718a8f6a694db25c934bb13326026004054722ef90496f7295fc0bdf37dfbc3c"
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
