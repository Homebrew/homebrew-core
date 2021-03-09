class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.9.2.tar.gz"
  sha256 "4a3b0d108a96c49b2c3a8ca0aabfbdc23dc0d7562bcd43410c2ba0834cdc07ed"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3a87c8b85cc7e12512de7e53a52ae4d748116ec15a53e6bd5bdd5a923c23031"
    sha256 cellar: :any_skip_relocation, big_sur:       "73397931a525fe989ad515b09b5b667245e58e0fd33c02a87c7b1fc9a7bd980f"
    sha256 cellar: :any_skip_relocation, catalina:      "9eb3c0d5a7ea2a89ff1b03f27b788a0137beccaca7278dfe018c6e605424c303"
    sha256 cellar: :any_skip_relocation, mojave:        "9d313d61552521508791ad9721c241c70641ea4b6e96ed515f99940b0b4e1dd0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
