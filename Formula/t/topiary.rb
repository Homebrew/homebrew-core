class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "d90cb9ec7684d36b157faaf4e2b3bd53833882c840679543eecbffd1036e7019"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba4ae09ed74f4e82ca182ca68a7254b08dbcd460b9b5f355558f64cc85d982e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adeacb55b4f3a3546e6ae0787c0afd97fde6ab4abfaed328706dc7fe8bb76179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d88328e54021399709400a560e8507dfd9e6b29114253d4131efc47000a47ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe506d454dcb769fc8cb2e0b7680d5338f1d69099a7dcc14e84fdd6b27fb04e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "478b22e372afa4592362c5ccba76f089850efa6e533795ff6b616baa6990daed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8cd290ce47d704c275ebd7270f1de192cb9628564fc0eea502a00db687a51b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    system bin/"topiary", "format", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
