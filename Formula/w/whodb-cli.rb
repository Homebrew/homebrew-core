class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.125.0.tar.gz"
  sha256 "c574892938c5a01a50e6f6e67d2fa53a4fdc30e1bae579dc880f66152c5ada33"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f598e2dc7dfec904385ae8c5a034441c1fa0b66e8455ca82fa2982eeba6b0721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5586a88cbb05283029dfa5cecfaa029dd51d7144d4f5eb2c034cbeda1d74c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a03fad279d930ee4468171ce2fe1ee9657416886be62d90d8fba27f91a3ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5bea82c29a7463bc9fabb776167420214b165991f9d5e85dc138ac88edf0d28"
    sha256 cellar: :any,                 arm64_linux:   "39070822fd55453310e383546e8844b7cfd0283492a854a63a3e5a8868e115d7"
    sha256 cellar: :any,                 x86_64_linux:  "483cfb26e3927a1642ef612193af0682264e5e405bdbe700658ee5d5603a1d4c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(output: bin/"whodb", ldflags:), "./cli"
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      The command was renamed from "whodb-cli" to "whodb". A "whodb-cli"
      symlink is kept for compatibility and will be removed in a future release.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
