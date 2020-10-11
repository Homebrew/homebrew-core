class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.2.tar.gz"
  sha256 "ec6ee6fcbf75d0baffbc1e7a29f889b84424cbedeff3806a76470a6e0564a99d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45339c152cd886a4700fccc27fb813308484fd03b394a1b734787cc790661ef3" => :catalina
    sha256 "e8ff35c6dfc6c3d1a0803acb0d7ee89ed2282db0ddb9072947a606ecfa592875" => :mojave
    sha256 "b2074ca0169eb4454ca7f4b0a056a283a4ce9caa41e63082b2428fe288aa03da" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
