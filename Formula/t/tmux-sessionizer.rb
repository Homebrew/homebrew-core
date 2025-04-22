class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "37cceae77bad373452d08b990065e7d1e8ed7b038a0af126aa4403332364530e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94a0d5bafb7636d4012332b0e3e5159dd9bb16d487aef5e1382527a26958826b"
    sha256 cellar: :any,                 arm64_sonoma:  "e8486f6f4e77a8bf58c6213e1f8e68f21e7611ec70aa96934d203cd3cebf9955"
    sha256 cellar: :any,                 arm64_ventura: "09d3a2e2a754b32137f1dbf0a329b3d49491806a31b8b031217a48444e7b9773"
    sha256 cellar: :any,                 sonoma:        "b3050eda58cd73739f53d11af0f6111fa1f5957757c7c5fe0cfa328788e9f1f5"
    sha256 cellar: :any,                 ventura:       "a5f2144f6d7464b5f8283dc94eef025a79a9c8eeb195efc12712a18ce80c3ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1c67d572a5c83597dacf9f0a67e2ab8bd6c24298c024739c8a13041ed0412f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a588098f0d380b6fd1ca53a697760e9d4d56a9d828bcd1e7a21041d488c18ff3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tms", shell_parameter_format: :clap)
  end

  test do
    require "utils/linkage"

    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
