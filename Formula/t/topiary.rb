class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3d7495caf3c0ae234bd6def6f33193e026564f7818d5909641be119de811f18e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742d685c177c33f9e988af56f8020bb3a5211b32658b39b59967980d0ff31157"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bef83cd5146326b685d2861fdf2fd861cc3a2ecf24268a1719dd390cdc2f6244"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "631e969c4616794c2290b7e9e3101ea4758e8a05cbac5ae55353bb0b6e02b1ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3643373a6fb7345ebeb252b5069f5a003be648dadc3c28f6e3c9546500218e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eff8fe68c8265471bf89472f256d1ae9188afd1bbaf8d40cd3c9b01b406446c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ede2255612729fe5e97f1757a36ec715c305f214af4097bcdc5517caffed29"
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
