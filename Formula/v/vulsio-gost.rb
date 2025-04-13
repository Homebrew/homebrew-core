class VulsioGost < Formula
  desc "Local CVE tracker & notification system"
  homepage "https://github.com/vulsio/gost"
  url "https://github.com/vulsio/gost/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "03e1155c8c989f1980c7392ed6c899bf74dee1bf577f0838521dda977466f9ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df9dc1b779c37edd3d593f55245b103b98584ba75b87b4743bfc04c0f59067b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9dc1b779c37edd3d593f55245b103b98584ba75b87b4743bfc04c0f59067b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df9dc1b779c37edd3d593f55245b103b98584ba75b87b4743bfc04c0f59067b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8050dfd7bd5560060a221fbfa7b6be492087f345c23ee9274bdfec1271d3af9d"
    sha256 cellar: :any_skip_relocation, ventura:       "8050dfd7bd5560060a221fbfa7b6be492087f345c23ee9274bdfec1271d3af9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a2ae9ca9d6b2d48bbe08312fe2e647319cf8881bc0393b017498f42acb8a20"
  end

  depends_on "go" => :build

  conflicts_with "gost", because: "both install `gost` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/vulsio/gost/config.Version=#{version}
      -X github.com/vulsio/gost/config.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"gost", ldflags:)

    generate_completions_from_executable(bin/"gost", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gost version")

    output = shell_output("#{bin}/gost fetch debian 2>&1")
    assert_match "Fetched all CVEs from Debian", output
  end
end
