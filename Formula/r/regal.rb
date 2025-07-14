class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "49bfa9e94f66fffebe963c886686cdf7a202f7d4fbe6ed59b02d13e0bd0e3fc3"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6439d599a24d1ab0885f6d082d7621b444b064ca0dcbb9e29f44fd1b8c33329e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb5723eff3749720cb162afa189d81ad5424a8029feef8fb8d83c007eecbd9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c44af338f7b3f076f324dcb8a443416fc6af6cf0cd08ce72cb7092b4ee7e977"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f0ac8650bd54f7a5a2d7d6b1e797afb11b212735e3d975710d078bed3a9953"
    sha256 cellar: :any_skip_relocation, ventura:       "fddf29897e7e6d552887ac13513821a5aa5cdfa1e8640cd087de51da28236f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "656fc7ad769f83109548130fe22248adb9de88b606401b48fcf33a8cafe07866"
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
