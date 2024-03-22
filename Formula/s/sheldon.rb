class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.7.4.tar.gz"
  sha256 "5d8ecd432a99852d416580174be7ab8f29fe9231d9804f0cc26ba2b158f49cdf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8531c07eb57023dcc802e1d3f488294f0ee22e364cdf04b8188db0510d5ffa89"
    sha256 cellar: :any,                 arm64_ventura:  "c76a61b084f19d54d276aeb651ef9f6d7007699979ced52e08785a635ccbc293"
    sha256 cellar: :any,                 arm64_monterey: "7d413db8b6188d92572cb5030b7861d4fa731e7bddb54dc5501cd7cee7b82839"
    sha256 cellar: :any,                 sonoma:         "f74c4d8a06138eeec623c99156fad09d223eab469bc57f0ce34890f4e0c6fc26"
    sha256 cellar: :any,                 ventura:        "62f89b239c66be2c9fa896f0b33893e9e8181060b18dbfd2884e832b64a2a3e2"
    sha256 cellar: :any,                 monterey:       "54add7d6552c888c77df6d15cfe43810d763a7de3e26fc9c588558efd328fbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8ea594ab59e45d4dd071e45752f20f877244054ab2c12c7002ab217feacaff"
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
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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
