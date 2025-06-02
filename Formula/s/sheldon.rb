class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.2.tar.gz"
  sha256 "8b9306902849344bacb9525051c88b34487767086adc93936fdef98c8650cfc8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f214f114e23f2a4777938fed3b864625dfbb3f9b30b142e6e05f8170b6cb0211"
    sha256 cellar: :any,                 arm64_sonoma:  "1c7a01151bab3c23c84b693b28c7b5996596520dc60d7f2356e9084c10fd6df5"
    sha256 cellar: :any,                 arm64_ventura: "84b4fe77d708fcffffd68cd051868c67ef143b3144cbd813b29f9197cf24b2bf"
    sha256 cellar: :any,                 sonoma:        "04d04507c5bc4e23dde5ac63cc6b96ce9bd723906d7bbd838f62cd5aa0746287"
    sha256 cellar: :any,                 ventura:       "9fd9b14e2cbaa4bc025523a6cedaaedf4effa56a49030a977af3d05d16fbdcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12cd2f0c98f949f57fea7345c648bfa96ce51984b08922275ce98fb4fbbce25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a83fc220e45ca5e917c26541c8f929b8dfcc7684bd81ec2b412fec9d68a3da0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  # curl-config on ventura builds do not report http2 feature,
  # see discussions in https://github.com/Homebrew/homebrew-core/pull/197727
  # FIXME: We should be able to use macOS curl on Ventura, but `curl-config` is broken.
  uses_from_macos "curl", since: :sonoma

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ]
    libraries << (Formula["curl"].opt_lib/shared_library("libcurl")) if OS.linux?

    libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"sheldon", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
