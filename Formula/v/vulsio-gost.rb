class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e96c8c8f29b19c3cb9b2288e91903d60074a17d0525333a7712ad03e248dd96a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813d140b549cab244bf2fa4de218034cd5066968ab0f869d64a74f934f017eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "813d140b549cab244bf2fa4de218034cd5066968ab0f869d64a74f934f017eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813d140b549cab244bf2fa4de218034cd5066968ab0f869d64a74f934f017eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e368bafbdbf01f8ca5e69331d3cf131626b5e69daa94fe43ec9944690dc067ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be514f0ece49d3c709983bb2e04c5754f555f534e32307e56be378637c1fef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a975a3784dd47bb8e2a5c71b9ad596c412231fb427ebf7496686ee1f8e309e4b"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gost")

    generate_completions_from_executable(bin/"gost", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
