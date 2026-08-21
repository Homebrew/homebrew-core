class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "bdad7f94e06f7fd13056adc05779ea5c9a3fcf1611e81940fa3fc7709c7f8a99"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aefd105de246475466e2380976a4733d98ae205c3921ec5b8599c1b1eebbf0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a44c8146f71015c80e88f23013adc7278950d1b7507c9cae256005592b1f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6b9d6fcc69307077a6fb98dc8d76668a8b060f94446631358cd0b6b2ccd5ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ac427e1f459091938feb40fffd8a6d8c496a0d185eb61e5f5c7fba317b3c96f"
    sha256 cellar: :any,                 arm64_linux:   "3d1fe77c281a926ae96bde81080bd20e9a845d77bcc8e70b9e179dd6d999345f"
    sha256 cellar: :any,                 x86_64_linux:  "20ef0ab80ef985feba30185c98adeea28542803fe3ff81bc9239a848e4b65f01"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "wasm-pack"

  def install
    system "cargo", "install", *std_cargo_args(features: "bin")
    pkgshare.install "fixtures"
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_path_exists testpath/"wasm_output/tinysearch_engine.wasm"
    assert_match "TinySearch WASM Demo", (testpath/"wasm_output/demo.html").read
  end
end
