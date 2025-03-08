class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "3027a04073dca5bc8fddce07b11801211fef31b43fbf4808675f0cc6d5c449b6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cbf5b731eb35404c7631da7c698ae7b9a56416404ace1c490e94152028ed60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ef672e4e3b2f19767e2a2c0aa435d20f39fd5fd07fd186c2ec6f62ea3bd15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "458d552fca00d5c742690e337c89a10c09b236f6b5cf446ccdec3cd3525ce7e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "322258334f17b2a4410e7d0856d5e0171fe5cff266eabec75084012319d33041"
    sha256 cellar: :any_skip_relocation, ventura:       "2a26493c0d05e3059bfbba9554700fd23481b67fcda6c079a3c35d1d7f26a0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c3575d0186d6a78088bdceb82eb34c0043cb49bd2b81467b335ded46b8adf5"
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
