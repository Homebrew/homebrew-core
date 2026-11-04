class Wayback < Formula
  desc "Archiving tool integrated with various archival services"
  homepage "https://docs.wabarc.eu.org"
  url "https://github.com/wabarc/wayback/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "b52cf015420852b99246cde0d0183ec746a1c851ff2e9ebbed80e05be7eccfa7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1e00be038a571de0c3fc1fa545f6b961818aad104ed0e1196339baedcba7814"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03fae71874bcdcc610263082f1850786599abf830c4f7a11bde7c82b8fed5c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d67fb8d25ce19684648df9a7c5e41ca21af11c92e51f104cf0e36c1a8c5ad22a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed30d6c06e3b3007c1dc002572b8bae31b517cee3ade1d0e7b535652edec29b5"
    sha256 cellar: :any,                 x86_64_linux:      "c86646a86fd54554d3835c003c2c74589e1f1ba6df2ef036c136b2f8bab388b3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/wabarc/wayback/version.Version=#{version}
      -X github.com/wabarc/wayback/version.Commit=#{tap.user}
      -X github.com/wabarc/wayback/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wayback"
    generate_completions_from_executable(bin/"wayback", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wayback --version")

    (testpath/"wayback.conf").write "WAYBACK_POOLING_SIZE=9\n"
    output = shell_output("#{bin}/wayback --print --config #{testpath}/wayback.conf 2>&1")
    assert_match "poolingSize: (int) 9", output
  end
end
