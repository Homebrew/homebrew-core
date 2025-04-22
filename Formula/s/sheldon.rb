class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/refs/tags/0.8.1.tar.gz"
  sha256 "fa0aade40a2e2f397f5f8734a0bc28391147ed6ad75c087f8ab7db7ce1e49b88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c88c02b826a8a2fdff6b9bcc20e583f89f6e36231c66a3ca273534b0901a29e"
    sha256 cellar: :any,                 arm64_sonoma:  "5fd35591c4061b133af6d60a72c9a14cb1fd15905aa02bdaae75afef04629c1f"
    sha256 cellar: :any,                 arm64_ventura: "0b6b02c0826dd2a73cd001523b14ebae3e62dd3eb0f0df3bf496e2c0f0472784"
    sha256 cellar: :any,                 sonoma:        "14425f9fa0b53c2fb461f2b0a494c29d03f39eafb1ea810868715ca5e32237ce"
    sha256 cellar: :any,                 ventura:       "616ba594572cc595a5351ce762788298c3b3683c6a69272791c57f9dec2eca80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c020679742a17b08cc1ec647d094e23bcead066b083dcb382fea997b61311df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd569988b6307ed86b2da07ccd34c07a8fab3f50a8a0fb596949c32232ca6230"
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
