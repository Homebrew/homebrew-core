class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "79cf097ca611f65d8134150a430a6843d98fa27d2891e650ddcae59025515bce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba1a4023db6d90cb11256764d737d6ead07a988501461f5fec015f016cb50f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ba1a4023db6d90cb11256764d737d6ead07a988501461f5fec015f016cb50f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ba1a4023db6d90cb11256764d737d6ead07a988501461f5fec015f016cb50f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c306175d1aedc0266307ed822db476cf145e7ec695a10b25a809c86e6dba73"
    sha256 cellar: :any_skip_relocation, ventura:       "e2c306175d1aedc0266307ed822db476cf145e7ec695a10b25a809c86e6dba73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde2ed2116cb2de91059df9561862880a37ba97ab615be4b893ba430767f0135"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
