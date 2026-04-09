class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.5.tar.gz"
  sha256 "a32e181667ec8bf235f0c50f2671d3c0d78fbdd7502a61e2f88c7deacb534b20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c847c1f57dab67c08f0b2bc28b2682ec8e82944693c08c9456a61faee416790"
    sha256 cellar: :any,                 arm64_sequoia: "f414fb4134ef81cfa8b07da7a4071cd74cedfd6201f6c9ca39cefb77bba18c73"
    sha256 cellar: :any,                 arm64_sonoma:  "7a2039f892bde698a45c4b4ddd4e4b01a68a800a78a25b6d264473114fb93953"
    sha256 cellar: :any,                 arm64_ventura: "db70e3bf9291543f442ef03f071c5e7f3a321022f74315a7ae2947f1d474239c"
    sha256 cellar: :any,                 sonoma:        "28e543aab665bd00bb249abdcc40b062f96a8305046136720772ec2d22afc55d"
    sha256 cellar: :any,                 ventura:       "e90fbe293693000084e563baf7af705d5fe82398340d90a7cf5079cc2d5a3f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb36c6d20e44524167470f658d6bf79dff452c6f2ca3470900d56c545f86724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f589b7843646d3253cfc607b0169a416a0017125e5b602b5daa82dab7fc8796"
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
