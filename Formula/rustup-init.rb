class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/1.25.1.tar.gz"
  sha256 "4d062c77b08309bd212f22dd7da1957c1882509c478e57762f34ec4fb2884c9a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ee3f915e1049efd38f7c4600a6c8843f8f7382f2f9683b4decbc635b71c524"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75d1be12dc64d53f7baf0e3743a0e4cc39c5955c5b484892ca35629ab3659b7c"
    sha256 cellar: :any_skip_relocation, monterey:       "85fc35fbacf815142d73a35d7eb55c5d3b00a86f289c5e9ced526df590fd1460"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90bf0b4bada9efb8a8734056cf298767b81179842fc02a8d70d01b3f8c67586"
    sha256 cellar: :any_skip_relocation, catalina:       "d72e4ef00102429c15afd4ff0a67b31f35d6cd920711ca9fae65c772b31be940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e0563f79d997f47685faeafe39cea1a49e1f932ed7799921ce6895392684ba"
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
