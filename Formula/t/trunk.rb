class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3f9127214abcd246d7f421cce5add03fb0cb1f5533c368d0f42a599faac1c4e3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fde742c0d61f45b3a75294c831d449b47f7251d2a6afca6e51d4ea2ba617d868"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6ae36a1bacd3efd32699b3a5ea87121d358d8d873b0db007d71d13beb379d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e1af5e6d1762ca1d393b8d47089c21b7903acc1bbc4a877cac73b6a3c13f33"
    sha256 cellar: :any_skip_relocation, sonoma:         "b38b12300f1e511b48fb25fa1b33b5bcd0df6c1662c8afc02a5310af62d0d795"
    sha256 cellar: :any_skip_relocation, ventura:        "97434590dca263bf74fc5a5f4db5e5700d07e8f105d8461cea417beb4af2913d"
    sha256 cellar: :any_skip_relocation, monterey:       "4a52d936801512cdfc50bfc3804cfc78833471ba0b4e51cb9824563ecf241e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8ed9633c0f1c130cda415fec7653a68370da3233555b18fc36da061efcd4fc"
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
