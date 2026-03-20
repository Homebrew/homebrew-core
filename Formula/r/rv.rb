class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "0c323fc834a8dcbc71759dc7121a14e36c86664475dcc3d1a7e8848c56a1371f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdd6f3262596f5c3215661ae6815917e042bc9cbf45b3a356242fc33176e87d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d786deeb0d6d610f42ca07a5b1146907a6e0f5f6b2b05c63ad3cac2a674e958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579efc1a868ae6903fef3825bc5396288781217a4bfdf0fd48840b7311b09210"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac1a53b7e1f5cd643654a64edf103d43d689f95734ea738819917537c3c179c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d04477826ae8a617dbc865044664fce68299308b418162b61a4cd61dc8dd2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d99e0354807d853e7aef8a07a4550453807857281387f1a3e7c23aa41b58650"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  conflicts_with "rv-r", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
