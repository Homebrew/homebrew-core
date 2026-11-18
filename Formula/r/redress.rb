class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.102.tar.gz"
  sha256 "f5491618496100b4edc43adc6de01748fde3b3ab3c008fc42a5eaa36a9b8ff2a"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ff5b1fca79a9bc7c97d04ff114b1cce559ce8b60c0c9f32f35a24b9d2a74b50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f96587a1c0fd9aaf221ff93351775e30f5a260f7cfc2deb00c75cd73bab34270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf8f3a70805a3e1d4c343c360bc51d4f9b65763dca4e7fad0bf1c9924d7ff010"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "089c8f2fe63d75a0ea804524cfae2592583e56de43ae8597d2615daed507a068"
    sha256 cellar: :any,                 x86_64_linux:      "9ddb62cb9e655f48c63e24964fcd6ff1fe210f8892c6b0efe15d83d78e441d81"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
