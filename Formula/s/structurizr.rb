class Structurizr < Formula
  desc "Software architecture models as code"
  homepage "https://structurizr.com/"
  url "https://github.com/structurizr/structurizr/archive/refs/tags/v2026.05.22.tar.gz"
  sha256 "5ddef1b90f2495552a6e87c23564ec7ee55fb8cb3ea611346addd7bd5b4d6e32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a9b5bb2997e731c27f8cd618480c3052f366d95ebb269eeae8cbd48ac669c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ae2b9cfc0e20b7fc052f6e61f00e5606a1c5eae0d4a7c862ecb02247d6c2fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "392e2761a3c1ce9bf091734b2450011d13de0de8878e34061ed2f74dff0f0adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc2d0ed7a0740a05bb7b221ef40b1ffe82151d445f0661f01c373c0e0236f904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adf04e1a696a065b3ce59aea6da20d8c79b91ab617059909f50d296795e26090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b522216987b51b207bfa8ea6b51e4770cee68e5b70153bfdb6926b92e570bf9"
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
