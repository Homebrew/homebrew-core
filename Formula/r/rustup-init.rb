class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.27.1.tar.gz"
  sha256 "f5ba37f2ba68efec101198dca1585e6e7dd7640ca9c526441b729a79062d3b77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1248c64af2a4c08f32d39ef40c4c65472f4d7cf9c447deeb7bc74fd6c8d1195b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbac142b00f35868ca7e34d2a5aa0e9922db072f38efd9fbb68d0bd4d4b4be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7018b1fe83019ab4c5925c79248bfd56b690ee65f7a2d9ff3eb6ef392a7aca9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9b11990998ed99fbedca4e8aadcb65d953f0f0711ce72620274b1b4d800c68f"
    sha256 cellar: :any_skip_relocation, ventura:        "a847079013df936ee23ee50e4bd4a4cabcec0e6fcbd3512efb11eabe3d514dd4"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e14890c70d0c103753a2861cda3b44092471acdec51b14ce0c7ffa1b10261d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9ff7b986a355cb60bff64754c0cb7213361a48e02991e246d8f7b242f38de9"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
  end

  def caveats
    <<~EOS
      Please run `rustup-init` to initialize `rustup` and install other Rust components.
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
