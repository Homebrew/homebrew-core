class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://github.com/version-fox/vfox/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "9cb7449c09d30ec55760658674077ff1208c6408cfbc6aaf567a36407626a0ba"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa2f37ecdb819e6162e28711a7c0d383acb77aac157a66be67b8b81f6027b2a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dab5a5bb6f495e32f96824a3663a5739b45f0ccb7d2fc79d7eff6c398a2882a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a28134fa3df38c47c1c0a1b7ee7ef387de402d5708a8f6c9e8c1db0b2fccd7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1ca3561e2c189d99a64ea77c258199eb9df844fa4882b1eb697768f6c160f224"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc11fe342adf197b825ee468c5d7827b535837a219dc392564ac257abd227a5b"
    sha256 cellar: :any,                 x86_64_linux:      "9e204a39d262d7ea9dc6be59f42943bbe70a14b78d9dc76f36b101e7284ff056"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end
