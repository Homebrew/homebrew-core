class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://github.com/spinel-coop/rv/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "905a2564062620a72fdf6cc2d1c28bb4756d46af5b211f5712539c1f13428808"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "317e7f657676aebb3b94e26d5d1d0a7baa94a5d00d3250648e990a3a05d21341"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ec1c20918acda6ef5f90cb07a58f9c50176789c8d8d9ab2ad0a48c00b80978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec47123d6b3016b2268242021b25d9bdac9d6ebdb3c17489a1300f1166fb384"
    sha256 cellar: :any_skip_relocation, sonoma:        "929f794def6fd2ed2cf280a5e17702986f1d261731f74a92af83c763eaf860c1"
    sha256 cellar: :any,                 arm64_linux:   "7ff8a85b0f49622bed8074c0f5101494dcab9c9e34b50fb05d9d303b8cdded33"
    sha256 cellar: :any,                 x86_64_linux:  "f03af7c67453b89fa910ae2a8dedbe264cc337f2ba1352b151357e82fc2234f2"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on macos: :sonoma
  end

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
