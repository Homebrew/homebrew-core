class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.3.tar.gz"
  sha256 "cf8844dce853156d076a6956733420ad7a9365e16a928e419b11de8bc634fc67"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "477d8d3f1311841c8dc38095cdcc58e41776940e7a94e15d3cab99022a4e223c"
    sha256 cellar: :any,                 arm64_monterey: "caa8e70400a4522793d79b52fc9d95e340017289a7346b67c162217046e897c2"
    sha256 cellar: :any,                 arm64_big_sur:  "88d9d05b05f3a469f998566f92bc829f33626480ea5069ac2cc244e05f1fe02a"
    sha256 cellar: :any,                 ventura:        "d4037a06d2b489bbfae6ccd3253c0a27f1c641e858f5da0ef1bf9304e129f3e9"
    sha256 cellar: :any,                 monterey:       "c576c653a4afdfcb24a555983d031a012e24e033346ce099b58560932b324da2"
    sha256 cellar: :any,                 big_sur:        "9387fda14c7f8d45beb23c30993d43129c68062c307519e4b91d79a440c1245f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c55430e3d99ef18ea8648cf076c522b08c27005b2aaff21b29373beb8071b9"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "libgit2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # Ensure the declared `openssl@1.1` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    inreplace "Cargo.toml", /features = \["vendored-libgit2"\]/, "features = []"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end
