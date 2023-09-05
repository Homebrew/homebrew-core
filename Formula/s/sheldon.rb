class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  # See comments below for steps.
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.7.3.tar.gz"
  sha256 "cf8844dce853156d076a6956733420ad7a9365e16a928e419b11de8bc634fc67"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "118dc8ee031a0b2b159c66e6dbbbbd42fe407270220e5ff07de1a764dd5acdf4"
    sha256 cellar: :any,                 arm64_monterey: "db0e38c468d5745f301fb3d90ef2f4aba554cd2e6aba7b7468349789aa25c892"
    sha256 cellar: :any,                 arm64_big_sur:  "189fdb36ea4f1f1d95b69a6e246364bc860a6d596064f22b753fa1edd1fb12d0"
    sha256 cellar: :any,                 ventura:        "d30c78b96cc49ee5074dcdb9bbd75e2b81305a2f940f83ea863ee8be12ef3b22"
    sha256 cellar: :any,                 monterey:       "cb515d97b3b15a9b0b41620a7790b117f0618159bed8dbaad5199e3c2d1039d2"
    sha256 cellar: :any,                 big_sur:        "70aced1caac7e5f67181cbf2ea32afdb73ada5be882049a9e1a94993bf8f9112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5b623285df6357937868aeb66dfb6b7d610deb01686e52d84fc351d62ecb9a6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "curl"
  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/rossmacarthur/sheldon/blob/#{version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Migrate to the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "openssl@3"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    inreplace "Cargo.toml", /features = \["vendored-libgit2"\]/, "features = []"
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?

    [
      Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
      Formula["curl"].opt_lib/shared_library("libcurl"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
