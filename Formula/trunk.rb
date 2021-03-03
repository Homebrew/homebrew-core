class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.8.3.tar.gz"
  sha256 "82a460a5c9a0b37f556d8bb208050b1f2a4fd20b51d403408a19f3582d61e905"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2090dffaf1ae8f174aa21b2212b1a5d39b7ac3d3f83d9697dc9ce4d46c4a5260"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c5418f432e211d6e1a4c4120183c397bd7f2995305a89f3b68a8828a2bdd7dd"
    sha256 cellar: :any_skip_relocation, catalina:      "b7391e068e182edc6b66ed9422aefd184cc3470afe6d90fdc805945ee1b5abf8"
    sha256 cellar: :any_skip_relocation, mojave:        "e08467d57b1d4bd383836e3f456a724864aa9926ce6ffa2f634b71e7838e34fd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
