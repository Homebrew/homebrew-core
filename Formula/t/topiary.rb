class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "864f91de6bd113c1be26d019e69fc248e037d8fba2814817c6263eebea673a29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dac6336757b9a2022c2c3f2225672165f4f9170da6f15d65151e0719b2921d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca84b527d6ec8ae8c6c234dae9278ed8242061f2a45ac291a8ca77854066cfc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5df3f21270366090265f6c68b953625b7bfa204938abc7cb59f65d09123e3b17"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e95fdbdbfec39a3f1d6b39dfca4a95bb10d7ad50b569a558b31cb806ae77e6"
    sha256 cellar: :any_skip_relocation, ventura:       "76cf060cb6a4f5710fa74e884833445e4c67ca7e3da7fbf4c4e13acc3a6c0b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6267e1f52e835088fb505f9c267f9684f278d1e874297386b43e59ab8960292f"
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

    (testpath/"config.toml").write <<~TOML
      [language]
      name = "rust"
      extensions = ["rs"]
      indent = "    " # 4 spaces
    TOML

    system bin/"topiary", "format", "-C", testpath/"config.toml", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
