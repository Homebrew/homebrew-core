class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "23ca2c3491d16ddac373fd5e35e6630dff8e4805e182ff094dc3c2b00f35143e"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded244f9354130ed50b14049cc36f1edc866adc898e02e81a4a5f3da2051e631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768b03a63f24135dfe44966a59bda8c5d3762654013b79b0086dc74fa9ca3455"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc1cded9f861171363e7ec19b27d3ff596210cd933f978f1da8348a8e9f90324"
    sha256 cellar: :any_skip_relocation, sonoma:        "58937a38d57e851dc74af97a19813c588a4670a46eccbe68bf181112b2a7957d"
    sha256 cellar: :any_skip_relocation, ventura:       "d4d3f252181d3ddbb7093d3615627aa0f09c7c7fd45a89fd883ee041fa613854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b158057574d696b0aaeedcc157f8127eff6a1bd43932bde5ccfd928440e39dd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/styrainc/regal/pkg/version.Version=#{version}
      -X github.com/styrainc/regal/pkg/version.Commit=#{tap.user}
      -X github.com/styrainc/regal/pkg/version.Timestamp=#{time.iso8601}
      -X github.com/styrainc/regal/pkg/version.Hostname=#{tap.user}
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
