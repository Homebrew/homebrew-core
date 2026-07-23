class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "804a38ed49279dc1e3b36c75d8e63ec0ee1659e3bd04feecd295eb142773f3dc"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c3b3a774eee8cb9148a39a41693d86e8bc385323705d24178e151efa5bf754c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3b3a774eee8cb9148a39a41693d86e8bc385323705d24178e151efa5bf754c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3b3a774eee8cb9148a39a41693d86e8bc385323705d24178e151efa5bf754c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d780d582a04ed92c1a69f3dd0d1d725b8f39df68d0ce6ff62534f2b4c8d956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3709d0a40e2515380896683e2b5ae183449577186f396c38f9c2e5c4e0916e6"
    sha256 cellar: :any,                 x86_64_linux:  "2d9f43a5147777b4ada27b821f34a035fd74732c3ebe5dd41301f07d81026efa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/regal/pkg/version.Version=#{version}
      -X github.com/open-policy-agent/regal/pkg/version.Commit=#{tap.user}
      -X github.com/open-policy-agent/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/open-policy-agent/regal/pkg/version.Hostname=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"regal", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test").mkdir

    (testpath/"test/example.rego").write <<~REGO
      package test

      import rego.v1

      default allow := false
    REGO

    output = shell_output("#{bin}/regal lint test/example.rego 2>&1")
    assert_equal "1 file linted. No violations found.", output.chomp

    assert_match version.to_s, shell_output("#{bin}/regal version")
  end
end
