class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.25.1.tar.gz"
  sha256 "4d062c77b08309bd212f22dd7da1957c1882509c478e57762f34ec4fb2884c9a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da743cec474c388a7774a7f7fecc458ee639d56cf4b47dc435717eb5e4476d54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6125eed25505926f523304ebb665122a3d15b3de19b482b3b84008c93fe28fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "597c38f3a49ada52ad08e863536254584294c7a4bf826d5c3ccc5ee658ff86f6"
    sha256 cellar: :any_skip_relocation, ventura:        "ac71a435b74247270060dd2b0beb5fc479ada984aaadf9a777dd5ae9f3896473"
    sha256 cellar: :any_skip_relocation, monterey:       "381604c17ed5b69af016c416ba9c19945ec86a2576fbfa331d7baff9c97c5d92"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf440be5aed32296c301664697f6e264c0262cc9949d04aed174de844fbdb98"
    sha256 cellar: :any_skip_relocation, catalina:       "2d62d01b7380cf2c0dfb81de3ecab619dc5350b35ce2edabc02062267023c978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd649820fb2f782f82ea48c4cebb9ed17ae547d2c6476c6903639b760d6e0c6b"
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
