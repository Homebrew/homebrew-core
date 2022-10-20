class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a166ea3f0a5f0bfd490cb36b3360b51e40a278e138f40a4be601faf4d33f456b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de6a50a196939ef8de1b56226bc90fcfb4d8c923d7e272070e9763989b6e7874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae9454c83fc0e8a5e2cd96a8c4fdfa98f3634bf18e4458b5d0adb3c23c4c36d4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cb19ba79149afbba9bffd5f53b03200b4be771f866ec34104ce897a4671d45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbefbb548fe76f81e9fcf33b2982003e27fcdcbd65ce77c9db882579a8caa55c"
    sha256 cellar: :any_skip_relocation, catalina:       "065e519c7ffec7ec0015e687b2d03622d128004475d360fe4e70372b5c575f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00fd4ae20a58edda0866fe5dbd5772d7535328375d540c36966a17e2c2d957e"
  end

  depends_on "rust" => :build

  depends_on "rustup-init"
  depends_on "wasm-pack"

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "fixtures"
  end

  test do
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_predicate testpath/"tinysearch_engine_bg.wasm", :exist?
    assert_match "A tiny search engine for static websites", (testpath/"package.json").read
  end
end
