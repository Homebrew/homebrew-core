class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "52643ed08c727aacf0f845b4ca81137ad1f65eb958c90535af9af9fe83e5a2c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64e96475b9f8566263a993ce2c4d5ddd00d8eb52c81e26ce86f311c397bd5883"
    sha256 cellar: :any,                 arm64_sonoma:  "5048fbb3c5a5f63c49edddf51ab55e2fac31a965c050ea3668abc9d2455599f6"
    sha256 cellar: :any,                 arm64_ventura: "ef7eef62ab2fae84b01a00fe0c7da0a61e44e1ecdc1185c0424d3b4634dd0a74"
    sha256 cellar: :any,                 sonoma:        "cd06cbe9c365960ea76a822978028d6a4500b6e61a8d6bb72df8419f634b29cc"
    sha256 cellar: :any,                 ventura:       "03c3d35583247af210f1b3a2001f93d0e27a40ba17b6125dea7575001c302d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baacf55aa0688b9f99ab990fd54607386f8ca942fff203f1fabb9406b770aad5"
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
    (testpath/"Trunk.toml").write <<~EOS
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    EOS

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
