class WasmPack < Formula
  desc "Your favorite rust -> wasm workflow tool!"
  homepage "https://rustwasm.github.io/wasm-pack/"
  url "https://github.com/rustwasm/wasm-pack/archive/v0.10.2.tar.gz"
  sha256 "533b7f63c04411e5d771d406b1c56134e3045b48fb1673985ad8fed1bc937517"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rustwasm/wasm-pack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e99d26010c73ec2764cde59f1083e1fe6fe8f21a207bb344bdabcf8f45c58b20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55a2279aed8c09a4920b0d233153103b5690ca02d9387df16df2ca3af15a5a09"
    sha256 cellar: :any_skip_relocation, monterey:       "44be39681d4bdb1233aec298c7b0f68b846137a355202cff0a84ec768bf8ee1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bffa30794e758b17acdba75cb2da3c1b18507ee92231d04354c58562476f3c2"
    sha256 cellar: :any_skip_relocation, catalina:       "93c0399b0b401bd314c37b99232ddc6a247269bcf2ba97c46d2fed1a3c512a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f311bb6acef7a9717c4d775932dbdae9f81ce9dcc948fb9c857f60281bac8a"
  end

  depends_on "rust" => :build
  depends_on "rustup-init"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "wasm-pack #{version}", shell_output("#{bin}/wasm-pack --version")

    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"wasm-pack", "new", "hello-wasm"
    system bin/"wasm-pack", "build", "hello-wasm"
    assert_predicate testpath/"hello-wasm/pkg/hello_wasm_bg.wasm", :exist?
  end
end
