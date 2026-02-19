class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "232cacbbdeea97e4a26b76bf6661944c4bc6f049a2bb04a45f1ec6aada4a1e64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "401272905b138a16ba76d89be9e75ae7b330240c9561baa732a65dfdcc1aa5a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f95513154e4c2877f5eaa0d7236c098c69616aceabaf157c3b7320cb7cbf25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3f6c7e399efe409986b17c5245a5a8131901f2209d47ed376e068a0d40e8ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "35af47c7ea270f0026de2894714920112ed6278a5a14448e438ed50af55eb51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43a124008acaba682e45c5acfae1fa7337a042cd68398fb3f31587a56d91a1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114a0f3bd3b20daef68f8b26c3b69bda416a461d9a790a410fbbafa5105f1931"
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
