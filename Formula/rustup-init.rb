class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.24.2.tar.gz"
  sha256 "a55ae51b4ba4f5db56e855a13703945ece42227370621f4630dfaa4767126f57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64b2636b20d6ff2fe369cc93f4d9e5ba1ed144fd7b2265aabefe21b54a4bd8f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "02eee26e1f46a4649e66c90358d1821f5c48379e69ffc90afcac03655b8dda9a"
    sha256 cellar: :any_skip_relocation, catalina:      "4edb96f7626d6a24750d63965d9a19000035aa01f69907982e89531c1ac1f57e"
    sha256 cellar: :any_skip_relocation, mojave:        "c34fd99f7a6249f02ac90650a8de7bd78b237f2122629795b8645420c3cdc6e3"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

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
