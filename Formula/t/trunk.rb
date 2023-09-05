class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.17.5.tar.gz"
  sha256 "308b5b24af739e779d05dfbb35f9bbfa87063e8532f09e6cf0b268951db3f604"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b8bff9b18d37680cae3b330df07f0816245c6659fe9a7f8862d5512ccf4bbd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ceeb7d47ea5e7c9bec2160f5d68681febcf10d296aee21c6a18f460cf3dcac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4e5027908ec6bba4d26697aa8044e1d02af138aa3f957442fc1e25df52d5169"
    sha256 cellar: :any_skip_relocation, ventura:        "60937f656bb0138d3e109b72a130e4a9725a1a3500693814be7f055389fbc749"
    sha256 cellar: :any_skip_relocation, monterey:       "69733721417dc26f65237894104efc04cf1dcaa4bae59b109842a89b15118f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de03a5fec3e832ab3c015bf1d4826cef4792cfc3fe458b98e3c5dfc88a96ecf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c9d144b8f442aa3c186be21974655679086cef8dfa0158e4314af31ee597e3"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
