class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "5f5d275b39054c7e879749e5d411bb4cf7ac50e023fd4f8890d69ce7085bc83f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84a9999489408a0df28a3c3a2b6ef3221875028047b915976cdf7734562b358d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e0814a5a4d9ff19b747d4ba9625305e47c4cfad8b4e2fb62ea42f01508966f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f32dca5487d698306fbf0feb4b4ebe6d4d0c33c3592337c0bd5835cf67195df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3e0be9fcc483c779220e87413afe3d97fb9d1c3d00c0e26f87b69ebadea2667"
    sha256 cellar: :any,                 x86_64_linux:      "79068f27483a8afafdaed815244c538c49b3e6778469c14e4561b4a2e9d1452a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "process 99999999 does not exist", shell_output("#{bin}/witr --pid 99999999 2>&1", 2)
  end
end
