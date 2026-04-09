class Restish < Formula
  desc "CLI tool for interacting with REST-ish HTTP APIs"
  homepage "https://rest.sh/"
  url "https://github.com/rest-sh/restish/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "3686e652193c976a04c96f83ee1a78571509e22169b83f7212a7380b374d24b1"
  license "MIT"
  head "https://github.com/rest-sh/restish.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9fdc528fbe2fccaca3bfab636db7872d1ede385b5709ed9c61e50085def7f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ef7937e4508123101de80ff1b78a6eaaee299c73207acfd8a7979a4b9e49a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d20de61133d8ea4332df51e6e452ac3ac113a7d555f95efab4840f03cbd1860"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae17b3c10c11df3bb120154a6801e30e61a98242f9e42cf29f20e3d4fe80279b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04054f2b8bbe4ae53bcb9a9b469d8e597f153ef2016bdf64f3982193d2b80cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33df4c0eccc2dc3c8cdca8c428ac26a756eac84750f3846ca0ff871aa0ff22d6"
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

    generate_completions_from_executable(bin/"restish", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/restish --version")

    output = shell_output("#{bin}/restish https://httpbin.org/json")
    assert_match "slideshow", output

    output = shell_output("#{bin}/restish https://httpbin.org/get?foo=bar")
    assert_match "\"foo\": \"bar\"", output
  end
end
