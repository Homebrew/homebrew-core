class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "ff32eadc02657efc0841be21273bbb618bcbd2be8c3ff0d09c49640ee4476057"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b21e9b1dfdf19cd342a5a13e841307d0dee9fb256cc2d5cd4133145d301733b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d53e0a9d9882cac9acd320861e91636f0bc49b66c49cbd77e68d6f7d086e71cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf67ab425b63c4d9ed4fe8cf561b05918dd82381f007423045d1f1cde828ed86"
    sha256 cellar: :any_skip_relocation, ventura:        "6fdbf13fd2b7ff59330313cc3bc0374fdeef1373b6be3a7fc1d647daa347a19e"
    sha256 cellar: :any_skip_relocation, monterey:       "a983f4a445910d56d77dd78762b98253ff6f725f419ec988adf556fb48d661f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "11530856d95edd863de891fa6abb69de2c4a8f911e3d4a14b16bbacccdde1ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f44a353586dcfae6fdb93cc11c3c8f950c53449c09c4803adfd8676f6063afd"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"rtx", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
