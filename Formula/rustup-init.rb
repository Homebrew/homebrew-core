class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.25.1.tar.gz"
  sha256 "4d062c77b08309bd212f22dd7da1957c1882509c478e57762f34ec4fb2884c9a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8c09a2f4d8abe14b495724fc79340eec85ef7972c201d5a4d4e69f4311a244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a623378ea3ea060046cdca23d25be6822e7a804fae4a8ba26bbfda8077c2cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "78a4230d82ca6d0bf3bb0c9d6881cef8b34a65880b13417c3ec11ea2dd36c95d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec03b64d38cc403694a3e90ae1e9e41adc20dd97f6539e26ef3c7171bc73f941"
    sha256 cellar: :any_skip_relocation, catalina:       "60ee77a62421bc5e32adfb73445e25243c85b6a9ab6a23af090a2a1089ec5444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370bc099ded79ff45b2b790a42138d88a85dd15a35e73611146df68947460c6d"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
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
