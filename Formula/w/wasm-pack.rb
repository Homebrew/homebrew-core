class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "d9eeb1116a584afc50ccb7c4ca15e0256453d4d2b4bc437b83f312b78432fdab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b291a2b6ff4b245bd920d183e9d6568386adbf6a7a7b837bdc599187ea3dec60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f9874054430a355a1b89f89a61ee567443b08034408848ea2921b7f98969499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed6e00095ccaa2ba64277113d6a4e12d41a16933c61e94f8ba1ac2a666f2e9b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19284846b04cc4435caed6a9ef012ea03fdb5dfdc35c9854c343b143e5cddb6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "92f0033ece6cc83109306625ab03dcbf3aafa11d350bb972d5dbf4d6babd1231"
    sha256 cellar: :any_skip_relocation, ventura:        "e9fcecc4da9399e5db97298e3270fd7b1ae2b2664a45285eb7ad9b82d4ecaf85"
    sha256 cellar: :any_skip_relocation, monterey:       "afbf975761f20b901d3b44540d0ba2cdd1493c4e8bf371b2c1577313faa55ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82499d28c9b6cbbc017bc939fbaef4b755c8605e4376da07dd1a482bdfdd02a7"
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
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
