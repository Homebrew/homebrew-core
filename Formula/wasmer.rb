class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/1.0.1.tar.gz"
  sha256 "ca5ea30bfd0700b5f89dace19516991dbc9ef38cf451f5bf11cab283e5f12777"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20a2801ac7678634d6a9bba906a087e8c2919d4909bb170107f551b22f605598" => :big_sur
    sha256 "1ee3da4752f580f3bf28799f26c431adbe59b812f2dac31eb0c3b2b91ac3e5b7" => :arm64_big_sur
    sha256 "cfa28a62f41f9869a70f28c21e1646ccc9a12f5d42fe60b6c67bf75a174a53f6" => :catalina
    sha256 "c14a9429f8b7f11213e09f359476780c41ad5b06a5f5fccbb3516525404aea7c" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  def install
    chdir "lib/cli" do
      system "cargo", "install", "--features", "cranelift", *std_cargo_args
    end
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
