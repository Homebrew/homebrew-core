class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://drager.github.io/wasm-pack/"
  url "https://github.com/drager/wasm-pack/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "60e866ce851219b18b7e16b2dbcd8323d5af0eac7d3a8a616bec3bd62fc051c4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/drager/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c12ac93a4e52a4b61b4bdb3e6fea208eaa93b9c30039babedc5957c0bc8d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ea3f4acbea89d2ef42c0b04336cbd739fe8abedc06199d708af7dfbe00bb7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2551c330819e973202af932f61610c8f2d78144081aefb839cc66cd11bb329b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c25bada8ea52c2d71c8f919567fc95cad7e9238bda41458cdbb5c160014c3708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5f303937f07117619ec2adb850245769636b4829c2cda9d9f3c6089879be82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46421d5f180137993d83ea1f60b902e0678971a562e18397aab8c57b8ec479c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustup"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    # Prevent Homebrew/CI AArch64 CPU features from bleeding into wasm32 builds
    ENV.delete "RUSTFLAGS"
    ENV.delete "CARGO_ENCODED_RUSTFLAGS"

    # Explicitly enable reference-types to resolve "failed to find intrinsics" error
    ENV["RUSTFLAGS"] = "-C target-feature=+reference-types"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_path_exists testpath/"hello-wasm/pkg/hello_wasm_bg.wasm"
  end
end
