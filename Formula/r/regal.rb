class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://www.openpolicyagent.org/projects/regal"
  url "https://github.com/open-policy-agent/regal/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "34bc0edcb3d23da88ed644a351112450b0016e110e6ef0349abfee103a2fda07"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a989393a22fed5c425914d468543632356c789aec52a5e40cdeb9f9eac199a48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9773d0e14bf3218a5cdf2de2c485e6eceeaf9368433947ec3ec825de836dc479"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3427efbe1f74c52823b2648888add58a7071eb33ad5d2eaf49ba7f4bacd72ac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c18b66cf3ca43dfb39d2fff174fcd021ec33743fd3d9afad9286d3927b3b479"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc976f8bc62ffb78fe0c86225581dfbec797e8fb57437203216d29810df6843b"
    sha256 cellar: :any_skip_relocation, ventura:       "857facb91526047c761196da0410ab7fffee6e43dab670542641b43b393d1ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1534d32b616e3e0a99163402425b8f4bdb7ff33f40a40f1d2d9d7de39ed2fc16"
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

    generate_completions_from_executable(bin/"regal", "completion")
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
