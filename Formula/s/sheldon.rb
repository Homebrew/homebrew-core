class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  stable do
    url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.5.tar.gz"
    sha256 "a32e181667ec8bf235f0c50f2671d3c0d78fbdd7502a61e2f88c7deacb534b20"

    # `cargo update --precise 0.9.115 openssl-sys` for minimal update until release with
    # https://github.com/rossmacarthur/sheldon/commit/93c32b6da53dc9ab8e915bd770280e6ebd7f6659
    patch :DATA
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6673cece9d7a8cf47b5a942825ba4f926f64eddfad1ffe760110c5fcb1576e05"
    sha256 cellar: :any, arm64_tahoe:       "a20cb1247992a8d40185c0e7517cdc8d6d9e3f208efbfc952a3c62e92b1cfd80"
    sha256 cellar: :any, arm64_sequoia:     "880a8185076345b4f60261561624eefd5977e15a987d4062c62bc389d707afd2"
    sha256 cellar: :any, arm64_linux:       "8e54907e8e245517b726e355993b6557fcc2f1c57891b398541226cc89dea506"
    sha256 cellar: :any, x86_64_linux:      "47adaaf91b6ba9fab3cb6f5737a9d821c062e005f550b151b72770cd5234932b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    require "utils/linkage"

    touch testpath/"plugins.toml"
    system bin/"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_path_exists testpath/"plugins.lock"

    libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
    ]
    libraries << (formula_opt_lib("curl")/shared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index d517ee0..0bbf2b9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -587,9 +587,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.115"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "158fe5b292746440aa6e7a7e690e55aeb72d41505e2804c23c6973ad0e9c9781"
 dependencies = [
  "cc",
  "libc",
