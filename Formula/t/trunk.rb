class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "195835fc7ad03109fcdb3a182797b3c318cb3dc1778da37a3ea7445994ac9b07"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe753746c6a4712ca329a0d394e86a2a1d72d41a6df0d17a8f35ef6745d21585"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcc47b73ca0eedf640e9d2a5341275e9324d7ab64d2cf7a832926869f0216614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ce58ce41ff4dafec065af6dcc1095f62f843683fa57a0597e318636a6c644b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2d74907880cef15849edd0d75275fb0f0257bd9283dfd0a24e1a0960f38de4a"
    sha256 cellar: :any_skip_relocation, ventura:        "eef4f0354b7f62ec70cff2f352fde07018d30e05b0ac90aab11eef0c02cd88cf"
    sha256 cellar: :any_skip_relocation, monterey:       "3871b06f126dd7b2d61a79943b10e125179d56bd9ebd95dae962f896a35566cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5018cd4eaeb8d74f7c83d8aad035cac9a5145418d39863ca9854371a7af202"
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
