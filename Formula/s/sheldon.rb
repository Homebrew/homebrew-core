class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.4.tar.gz"
  sha256 "564fbc59f0cc0b8e8734ad2e9594dca6eaffb9d9557d8f7cb5033168ed8439e7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de1d90bb64d5d1f5d2eb78c0a9d0b3ccbb910f8bc1415eb1f475c147c242b651"
    sha256 cellar: :any,                 arm64_sonoma:  "61992451ac6c8652073acfc3a1382877fd4758cfc0b9d6811f1fdbffddf7ca0e"
    sha256 cellar: :any,                 arm64_ventura: "3ef397d1bec3914f0cbab1c1601c8bb3884793f1fcb1c3d8be1be4a2a5b28c94"
    sha256 cellar: :any,                 sonoma:        "80e00d69ab0d8566d6723648ec46c8067dd355d31c18fc32d275481ca60a0212"
    sha256 cellar: :any,                 ventura:       "fe89e45714a75cb8d828286da9854fa4f1f682bb878761d593d94eaf906aa228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98bb44bc236b7ca8707ffa4318273e0d1ce59efbb96918fba8acd7f71c219ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251131d1853bbb40a8ed006a746d5b8142d86acfe1112444ea047fcbfa175b87"
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
