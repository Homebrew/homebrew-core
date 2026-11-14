class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "baa2571e3a8247527f056eb10e103069303fbba1f705adf6c2e264fe95f48ccf"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "712630c2c63283debe4ce9a68a57bfbb2d21d3b6c7487827407dbec272a7a493"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7504602b2e728dc0eadee52e6e04bed0d909c46f64a9480774b932e01069e2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6479c6e09576060f6f35e1a35cc84a46de8bc79921865f34b8f575ab347606bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4730c42aa3cbb663877be5073004c29d4e6cd2a06dda0d5417b8bcf24e265a77"
    sha256 cellar: :any,                 x86_64_linux:      "8b2f5bfdb65f530c97454df65bb4a426fc9d2cabc1716d008b3bce0140998444"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
