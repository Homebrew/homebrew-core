class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.0.tar.gz"
  sha256 "71c6c27b30d1555e11d253756a4fce515600221ec6de6c06f9afb3db8122e5b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cef072269673d984ad6652c14124942d829d6c09ae97e717d044b12950fae909"
    sha256 cellar: :any,                 arm64_sonoma:   "92282f5ae930b2bab08f86cf2baaffb54eb88c94847b5c1abd29a08addf9007d"
    sha256 cellar: :any,                 arm64_ventura:  "2224e9f9e5ddcf6239dfe92b269ef06d942c4cd5d548dcd31d1d235fe03617e5"
    sha256 cellar: :any,                 arm64_monterey: "7f7f7970cf7c2fcd1b10972db6ac9a2ce1fe98114d051158d775c92986cd8e1e"
    sha256 cellar: :any,                 sonoma:         "3a40d9b78e571efbff661f8e19f61bad8d2337c120395489a7ac1d530b88a552"
    sha256 cellar: :any,                 ventura:        "9741bf2aaa1e807893582ace21f69a93f529633d9641022accd890e58eb65bd6"
    sha256 cellar: :any,                 monterey:       "053bd969792bf0ff6ab3c8b7447bc15e1fb787cb1e51312b9aa54e4d47e1b168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484a82b6474cbc25d40ce7a9a3f0fd562438fb6dbd218bc3e0d856167235a4a5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "curl"
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Replace vendored `libgit2` with our formula
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

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
    system bin/"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["curl"].opt_lib/shared_library("libcurl"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
