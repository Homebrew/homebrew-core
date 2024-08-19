class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.7.4.tar.gz"
  sha256 "5d8ecd432a99852d416580174be7ab8f29fe9231d9804f0cc26ba2b158f49cdf"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a2db8cb394042a1c47194cc4a7e984f6c44673250f29a6b5acf3b696b77c7ab"
    sha256 cellar: :any,                 arm64_ventura:  "bcc268653a24e93c6d962b14b2ea9178da9e9c014b0857462e23c1ef6ba415ec"
    sha256 cellar: :any,                 arm64_monterey: "5bdd2253413e00bfddd16facb5c50bbde168c7301fad21468d3927ad07acb2de"
    sha256 cellar: :any,                 sonoma:         "6c4779967ca51800a092dd953c5561108489e98f932cb0d9163ddc814bd7edd4"
    sha256 cellar: :any,                 ventura:        "a067fd334a5eab9ff823822ed49e02964b7b68495c3ad936b4d09031f0ba94ef"
    sha256 cellar: :any,                 monterey:       "d36a243b2c966b69116b7102066eb6c72890369919ef27691c3c1be99bb72989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d084dc5c851cdeba81279ab7262bae8b8978a56275297e9f7a075402f0421f15"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "curl"
  depends_on "libgit2@1.7"
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
    system bin/"sheldon", "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["curl"].opt_lib/shared_library("libcurl"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
