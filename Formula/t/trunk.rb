class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "a572c4ca842c4e5508dedd48bb1b216523c102fa2d8b5517efba004ad6b7e27d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a2aafac4d1bdfef1bfb6b40f4d4f0dd402e73e038f9b7e343eee8fda6f21b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5eb52b92a48fe0d9fd5a862a081a7ce6d2406bebaf53a83b59f2eaf0e31e60b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d62865076d8c6ad527777e744d961fae37452dd7c3998053906ff08a29ee88"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce06c672eaffc29d2a020191a9208c76d2387a82c1a85df5a2cc25f0524e3e46"
    sha256 cellar: :any_skip_relocation, ventura:        "58bf3255e0048ea5ca76259c488e48bf117cb9c0cecf471d4f3d7ea471ace3ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0655b2f5f0766ab8c511286410744edf3d3b1a72de2728587e74efadc61a906a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be593f321454d3358dcaa33277219eefc4df7ef26c076f3676de86a24e7402f3"
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
