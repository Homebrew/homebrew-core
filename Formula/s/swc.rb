class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.43.tar.gz"
  sha256 "56f9d348cb5f41db294bdd8db6970d2bee7171ea5250c1c31373a6816eac9900"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dc1b313823a38fd041bb9b61cd962edb60c9920eae52d309a64149705fb9273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c327003617451f1d76126447c521fc837b349a61986196f14a755fa93b0acbed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5872766386d231dbb7a857e1bf20712f7bb45e8dd5794bfcdea1d837c79c9692"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e110994f3e0df9d8e6ee8ef0c32f2a94de444ca13fbca8478bc77d35a093868"
    sha256 cellar: :any,                 arm64_linux:   "39666898ff931333d73054e1fa22e77acc383d7ebff0e616f2e63fb2f04aad0c"
    sha256 cellar: :any,                 x86_64_linux:  "3f30dcb6328d940c691a0c20440899ea5a2a9b3490a6a516c8ca6a5131828c7a"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end
