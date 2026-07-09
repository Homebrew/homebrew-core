class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.2.0",
    revision: "93bd021012baafda53df2030db3ce1758dc1e336"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "961c0ba78e0f491d887b6eff9bf051c5e1bea0f68eea08f41e43c7fd4a399f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49c61549c1790467ac41bb8adc3e0202da7078a8f9291b628449ade17fbdeabe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1263e169fcacbab46490f79edc2478ac44ccf233102c9e4455be13e8a13e1353"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2aa6953fb87c76c2721a9d883cbeb162d94d022f698e78ee89a3ea33dd9a2ce"
    sha256 cellar: :any,                 arm64_linux:   "3beba82bd7aa29a58b53546430e8cad3ef597976c975b6185aadfef27adef823"
    sha256 cellar: :any,                 x86_64_linux:  "f97b76d486ed15396f7c6e9b600f3f0f3993aeea73c4f345983a47614bb59f5f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lib/cli", features: "cranelift")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
