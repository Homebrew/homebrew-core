class Regal < Formula
  desc "Linter and language server for Rego"
  homepage "https://docs.styra.com/regal"
  url "https://github.com/StyraInc/regal/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "ced1e3c6d6e9652b87dd84d2ea828c493eb33b858da0c8f2da8d23e404331bf2"
  license "Apache-2.0"
  head "https://github.com/StyraInc/regal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731746fe9d510ff77511d631eab2d8c142e0469927151c8fb1e49deaad56c4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f612566e2e059475e038c5f299a01c83c39f455d573ec5e99eb043d945cb12b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b24db853f3d38d9e6f0050fd11afabd71d76c8b77154e25fd048195144275bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2798e9634e25f51f45e3e5a3e5135760f00f33ce666ec80041a381c49b9b554"
    sha256 cellar: :any_skip_relocation, ventura:       "e1e23a0695f4814f4416ae9d9f88949997c6614862d920df693487beb391365c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16762017788d066c91828f619c9801439900144e8a5f14996c7aa927325586c8"
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
