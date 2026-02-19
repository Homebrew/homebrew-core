class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6262df7566e9bd5557f60a9217258cbd73bc62061c74fb372e07cf4188775ccb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c9705d7d8912da7e4a11f967b57b026a974a3232a998e3cf555c154f668f0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "139c066dad7c16d8da58919d2d48f7aaadc41237f300c3632a88e5060d41f282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "252f534d5748d9f8d9845c878eae6e2f39664ff2ee0f0fcb25c9a74ec9eb8418"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60b2fd76408155e7dc31bde94dc8253cb59cf8b7ded087be2cc794d451e76b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "14490663c0beb01f76937ff1023980806e75d51bb97912f00f2490f7a485bc09"
    sha256 cellar: :any_skip_relocation, ventura:       "c05ac327ccaba7f59ce94631ba82d4083ccc442de3232f3513292c6f759d66e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2372210d0075d8b401f1b5de4a06359432aa6489cf6e3fadab578cacc67e4329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7746d68cca7ebd9ad68eb6e0ead34dfed4741b924b561abaaf5c16ae4507c9ab"
  end

  depends_on "rust" => :build

  depends_on "rustup"
  depends_on "wasm-pack"

  def install
    system "cargo", "install", "--features", "bin", *std_cargo_args
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
