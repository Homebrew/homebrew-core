class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.26.0.tar.gz"
  sha256 "6f20ff98f2f1dbde6886f8d133fe0d7aed24bc76c670ea1fca18eb33baadd808"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5403ee4bd950803e8ed34965dfa3e78c7792ce03d1a337f3d67e48883497030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ee31e98ee99ff9bfb19f645462c92f9df736bebf964f7e1fd6cb929f2c4b50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84d3671025bcefc14b427e62f0352561aa696002d3655790c3372e1222e2966b"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a2c614a74764bb58fd568138ff6ee80017f15bb13584537cbab9983685716b"
    sha256 cellar: :any_skip_relocation, monterey:       "e05a314ecaaa08f165af03f73eab8881d629eab7a806fedf55f71a650ddf55a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "69270c18e89444aab0d46a02219c5f64207b11864c714083abf237e442d52b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8fcb01f9a618e4cdc229247ce47bff31b38a2d606065665e27928330aaf3abe"
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
