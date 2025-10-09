class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "e6f02e9493466e70d1b65f3c1db36da9e9789a5dd89935f1a5c307739e8c3610"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "661bce317441de9df0f057f1e591764850a767e4034febe5c0e3ed36228537e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661bce317441de9df0f057f1e591764850a767e4034febe5c0e3ed36228537e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661bce317441de9df0f057f1e591764850a767e4034febe5c0e3ed36228537e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba9a8332be6acdfc1847f83c326959c9cf2c1da5bb69395ab966d2ee07a436d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3f3647eaa0157b9b5a3417d9fabc67baec6703086f600535d52e9fe65d2f272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e793dbd00ec1a15e5e075b934d45f224fcbc69a163d235a97141c7c1f61c3ec"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/transcend-io/terragrunt-atlantis-config/pull/404
  patch do
    url "https://github.com/transcend-io/terragrunt-atlantis-config/commit/b4538b1c86bf1de054338e5d6c69dbc975c378b7.patch?full_index=1"
    sha256 "be88fd82f3816cd6dcec9c590936cf9865400a333c8f035bc033991fce789b41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
