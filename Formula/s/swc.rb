class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.46.tar.gz"
  sha256 "350a7e19747dd9bdb98d764cc72281849ae7e1e26c33a61ba6052404a1321d22"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79a87625f451be8ba25389f482224ef6955d4e82a5c0f2f81f8e590b404bdada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6af5d66a4b83cece3355bb7f673aedbbbb687756b171e734dc0044d77b6581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9399c78ca0d08446bbb80600bd8404e4c029a193f672194337471dde8e79846"
    sha256 cellar: :any_skip_relocation, sonoma:        "43fffa0d8ab6d7905414d6495a6fd22f05c3d2412d86862ac19733779f69f59c"
    sha256 cellar: :any,                 arm64_linux:   "17783ae8f317e8b55f382eb2445fc347d85693d10633ab114c91fb9b3fb5841c"
    sha256 cellar: :any,                 x86_64_linux:  "96fb1b1f39c41220363f4ff1502f0e9309a57989481ba1dc21a479f7f23625f9"
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
