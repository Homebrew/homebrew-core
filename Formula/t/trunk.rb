class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "f17959b6f1c7d8e52ac8e5d38507ec5cdf2288c1615ec04e4d51d2d12dd2b510"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7bda7c88a7b7fc8442bf33c74dd47ec88e7b6125d9fec812c27d6f121d9e1fa0"
    sha256 cellar: :any,                 arm64_sonoma:  "ad9f71f62fd0ecd90fb28eb4f0116acb8701d2156fd6288ae8cef60de80ad1b6"
    sha256 cellar: :any,                 arm64_ventura: "a54b8a400288b9a066982d852f95a1550ed5cabb2decabdeb589ab7437a7e64f"
    sha256 cellar: :any,                 sonoma:        "b8a5ff3f6ef484e20df3f4df7c4ea5559f302fe2eb67efebaadac45a44f5a6bb"
    sha256 cellar: :any,                 ventura:       "2726aa2121fbaf815ed6366cf0beef833325c8ee15fc75acda9ba233073fb331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6bf06af4f18d5eec1541a9ae2d69e66b0087911605aa11c7655b3e6113191bb"
  end

  depends_on "pkg-config" => :build
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
