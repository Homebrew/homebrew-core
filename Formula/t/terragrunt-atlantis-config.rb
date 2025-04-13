class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "b21ee84341cd94ba369c6f0b3124f6d260ed9141129e345c6c64d76b2f54ce91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a77276086d50d1a244decd8348f84ed0cf9782f78e3c15ad81ee1a931ae4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36a77276086d50d1a244decd8348f84ed0cf9782f78e3c15ad81ee1a931ae4fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36a77276086d50d1a244decd8348f84ed0cf9782f78e3c15ad81ee1a931ae4fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a52d65d271801ec108c1f61d041c0cc098840064035908b7f91c238b044838f3"
    sha256 cellar: :any_skip_relocation, ventura:       "a52d65d271801ec108c1f61d041c0cc098840064035908b7f91c238b044838f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e172a88a31a81fca1a9efac6efea8e6bd509ea68d809ceed5354fc5fd5d17f0f"
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
