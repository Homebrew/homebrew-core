class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.13.tar.gz"
  sha256 "4dda5470ab2e972041804f8a5028d784bb526dff3d5a0d574221979f20ed8ac3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2a226efd21def510134c43735d5fadcc293766ef80f06bffc382f4e6be3c26d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a98a988a4d9148013532b3e0ea81b35e9ebfff33a821158b511557d7ad462345"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efcbfb98571c2b77909fa02250caa52c818b71015e74bc753c2c8973441870cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0359ea6d7a606d9275cbe0615ef627a2bf50773509426549b7fbedf8008f675"
    sha256 cellar: :any_skip_relocation, ventura:       "dff27d25af94d36a884664c332098036fec3a1ece878fec25dd87c6ccf208717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a02fb451ca85699a0431d8a722b82bd4f626bb80f04f0ae21970d532df51d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39456d7ea40391b5d796841f9001a7f115bf13d0051003ccf68fcf5113a5acf2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
