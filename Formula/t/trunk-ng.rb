class TrunkNg < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/ctron/trunk"
  url "https://github.com/ctron/trunk/archive/v0.17.10.tar.gz"
  sha256 "3e3987f8b1e3673a446ce1babff9b4280f36d10d8a7480422cf93c6aee9a4296"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/ctron/trunk.git", branch: "trunk-ng"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk-ng config show")
  end
end
