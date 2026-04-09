class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "b42f7dc0640500b78a04ef26f2ee35b1a1d1d7c6e3e942eb1a55d23b1fe84840"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38c9dc42a238d294e8af8d1845a95d3f78653f50a6e85156bb612953afec71ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c9dc42a238d294e8af8d1845a95d3f78653f50a6e85156bb612953afec71ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c9dc42a238d294e8af8d1845a95d3f78653f50a6e85156bb612953afec71ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c5bfc4a88448032222accf5a1c995dbf2a7407385aa65be0137c2394f6b95f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "958b0dc157f3981db595d4e07cacf717584060e637367ea075ebb734fe0ce018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63569d05111bc400e338a73131f2750c3f24e8f0d5ccbe8132182542a770d9b"
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
