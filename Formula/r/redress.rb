class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.67.tar.gz"
  sha256 "fefc4e948ad6ee0e61e7dce4d9e931428209bbc45dda1b71e48bc3430ec269e5"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e7c7fc0c0c67674ab4b47a746b5a2a286d5becd9ab374b02db109b6e61efa4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2e3a0881170c3a223e3b3a15607e946bc9afa6847ddeb1a62ae18702e7403b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f9f7943397367d2d73e868326c08f83c18e42f2ab5f5fdbc0169694cf10b27b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a31a0dcb000dc619e39875d9928967b386690d15371cc93f9e519f1c7d61305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68fd5aa7379467db66496b9d391bf2f0fd72dcf5179c16afebdf463f863b1928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1a41510d7a64b898875006702d01e689fa7cd5aa0bc28852a7fc8b3aa24e3f"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
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
