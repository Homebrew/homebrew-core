class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "1cd67765b834dd509d29fd7420819af37af852b877bc32b31c07bf92d27ffd31"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ca5aa4e2349a5cef9b277ccbd3040b7b57dddbaee41788e2734a597af44ab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ec552035a8edd72cd462a1ef4e991e2f8a174f0f483d506c172db54d186bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ed4dc185c00a0cde9966c9122aa0abb3e6d5def3b1358a6a997eb4ff753c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "af8c5da656d665fce998bfbb1fd59c4874270183a5592f45bcefa34c922a9207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851013b1f02a3bd26e55eb35e84bb8b387504cabfb8dc858c45d4e854d15e787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "976886b95d606f2b1cd6eb45f35fad3b36a6039af6a2153dfd8d4125ea5cf8fb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
