class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.10.26.tar.gz"
  sha256 "cf841dec442e4cb4970ce3bb692eacc55e8e29cb755a4e557091d8d5e575beea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d90e0bc830044703d251452daa61d0574c01d326f2baaf4d0b5664db38094cf4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d90e0bc830044703d251452daa61d0574c01d326f2baaf4d0b5664db38094cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d90e0bc830044703d251452daa61d0574c01d326f2baaf4d0b5664db38094cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e29af0bab627d6a7e2d1f6a6fe30f86481ee390ac5fccf9596eb1835000b3da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e29af0bab627d6a7e2d1f6a6fe30f86481ee390ac5fccf9596eb1835000b3da7"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-Dapp.revision=#{version}", "-Dmaven.test.skip=true", "package"
    libexec.install "structurizr-application/target/structurizr-#{version}.war"
    libexec.install "structurizr-mcp/target/structurizr-mcp-#{version}.war"
    bin.write_jar_script libexec/"structurizr-#{version}.war", "structurizr"
    bin.write_jar_script libexec/"structurizr-mcp-#{version}.war", "structurizr-mcp"
    # NOTE: excluding structurizr-themes due to unknown license for PNG files
  end

  test do
    result = shell_output("#{bin}/structurizr validate -w /dev/null", 1)
    assert_match "/dev/null is not a JSON or DSL file", result

    assert_match "structurizr: #{version}", shell_output("#{bin}/structurizr version")
  end
end
