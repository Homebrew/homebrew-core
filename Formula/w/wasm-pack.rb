class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "3c28be53174fd12a6f3c3a018f14c8383b2eec6c6699c74751c1f3c51a2346c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015d79bf605e1c7210d9662f663bd625d5ffb198b4b05f057ff96aeda01c4157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747c2699cacc93a426a98bab721cf4fcf70d04f041b9f985c5c28351823a3179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5efb6426299ccfea3127cb7132c7583fd54d88072e623cb02f11532da201f243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4721dbfd0281026391ea9d413a1e23c0bfecf803f370305a1c2e209234c1326"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ad5721098c7a62a35a817ca06af6a249d02d102e3739ce029809b6946824f4"
    sha256 cellar: :any_skip_relocation, ventura:       "e42e4af8958a1593cbf06ed54a645512e1fd3f51e447b5c12882bd67f6fe0528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a30ccc8550215b641f2203ce5375b53b5167f6368421243fd549fa68a4920a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ddf3a9d0f664911152c681c589f4751b92c4ac1c172b0f366b275a4dabfd5ff"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustup"

  def install
    # We hit a segfault in test using pre-built cargo-generate < 0.21.2 on arm64 linux.
    # The logic to use a global copy from PATH is broken[^1] and a PR[^2] to fix stalled.
    # There is another PR[^3] to provide an environment variable to bypass version check.
    #
    # [^1]: https://github.com/rustwasm/wasm-pack/issues/1457
    # [^2]: https://github.com/rustwasm/wasm-pack/pull/1330
    # [^3]: https://github.com/rustwasm/wasm-pack/pull/1482
    inreplace "src/install/mod.rs", '"0.18.2"', '"0.21.3"' if OS.linux? && Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_path_exists testpath/"hello-wasm/pkg/hello_wasm_bg.wasm"
  end
end
