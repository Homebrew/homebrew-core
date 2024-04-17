class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "61876cd64a2a641cf30db0dba400cae50f0d73d33394838abbbb5636d12f3db7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46e0351e7080b784f5a71cd5e59a4a5e654d83c8d5ab36ecac171d79f2558d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5484eb97aae92f43bdfcb26e57a8b2026eb48187787120b2209c88bedc26ad44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "167bec553c8af7b36473a35e2cbe723b474fd68e8ca350c41d79976d531522fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5530c439db4ad597fad9ce65a7ef2996339337118d43abdf4d89eab7431fbed"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7a6feb0dec5a211e5467381a48045c1f5895cd8471d305a2500b0053e3f76f"
    sha256 cellar: :any_skip_relocation, monterey:       "bab67a7743bbe9ef8af84ddac50c6c29d6671704b36886aa5b3073604d4d2006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db3295127af398280a5547625592a227c086b397dea88869ac478eec3f3f25c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
