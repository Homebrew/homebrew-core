class TmuxSessionizer < Formula
  desc "Tool for opening git repositories as tmux sessions"
  homepage "https://github.com/jrmoulton/tmux-sessionizer/"
  url "https://github.com/jrmoulton/tmux-sessionizer/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "e7baf324409af475a96d2b034a2ecdb46452feb7d0ef3ddc41e834475063a1f7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "856bb1845ddc7b122b5e1c1411f3b1efec1b10f7f7d8cd7825516e3d64985093"
    sha256 cellar: :any,                 arm64_sonoma:  "4eecde07cbf456447348407bfbeb168d9bbb5ab7422b5afc987f6f00343f0c48"
    sha256 cellar: :any,                 arm64_ventura: "0c2dca00b8329eb11bff783dce4470c945dd510f857ab4ccbe51beef8c025123"
    sha256 cellar: :any,                 sonoma:        "37a87c8526ba8cc58245e68aa4b098c902190dfb39f6eb142aaa8c50b5d2f49b"
    sha256 cellar: :any,                 ventura:       "e5dd40efaae2b712ff400f6f427961f5d69dbc07ac9151610341e6c8a38c125a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdfd99713dca02e0cf69606d685cb4898748f3c98122a4a1e310499b3c9ccfad"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"
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
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "Configuration has been stored", shell_output("#{bin}/tms config -p /dev/null")
    assert_match version.to_s, shell_output("#{bin}/tms --version")

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"tms", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
