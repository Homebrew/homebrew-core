class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "a441bd912e7b462674f039a46d77dcbe20da0bad1eb269746e3546d05c77d7e3"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4b288cc68ca5dd1b994e9939fb942931a45a34a24e9a79382c47a2b0bd7253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a35bac092bea0583d31e51c45847dbb60a188a0a9a9de92ed5e4cfd3c4072dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7aad75bc3bf154d62cc4dd31783f122b6583c3aaefb60b867188bc582058cc13"
    sha256 cellar: :any_skip_relocation, sonoma:        "889d1339a8cae5085ea48ec0e0771269fd96e6e5280a485fcb252e608dd82638"
    sha256 cellar: :any_skip_relocation, ventura:       "6ebfa3c2e985b406ff866c127a16a25db15112060456085ed27777965ccdaef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66dc139aefda301f748840c692271b6adbe85e906d8fc67119a85d5ceac0409a"
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
