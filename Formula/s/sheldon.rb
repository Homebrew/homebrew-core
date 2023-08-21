class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.7.3.tar.gz"
  sha256 "cf8844dce853156d076a6956733420ad7a9365e16a928e419b11de8bc634fc67"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b24b3fee34c0c3238a23b78d8232629a92bc4264f954f1e6eaa2fdd16330df1"
    sha256 cellar: :any,                 arm64_monterey: "7b6a23932b20209f6b42659e2b4444f9dca2b2f63b51791a7cf7752a5a739e4a"
    sha256 cellar: :any,                 arm64_big_sur:  "c6d86976e495da8790c18254cc10dafadfacbf17b4b9098c2547697451b8a3f8"
    sha256 cellar: :any,                 ventura:        "0b2588ca3661de9c4e3a158bb00ddaa110c32d4aafc441e7e303308558697cc8"
    sha256 cellar: :any,                 monterey:       "b5c654a04fba02a7930c78ba5587a89a401ced8840af80d217c48117b5e0ad57"
    sha256 cellar: :any,                 big_sur:        "0c360e431327824b762897b0396d267d7e2c04039451aceeb24a75e8dbe5c9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c2e08181dcf2ea7b34ce3e6c1174fb90ac60f89f9d1006b4206cd3f71a028af"
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
    inreplace "Cargo.toml", /features = \["vendored-libgit2"\]/, "features = []"

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
