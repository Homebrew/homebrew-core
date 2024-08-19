class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https://github.com/memorysafety/river"
  url "https://github.com/memorysafety/river/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "7c3aebe1e60a53d2d80b81db6b074623b7797570a07dfad93c7f6ae8df0f9b37"
  license "Apache-2.0"
  head "https://github.com/memorysafety/river.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46262a1e65759a7bb82a2bad87a3b93e0f0ff026058e7b7395f0414d48ca11cd"
    sha256 cellar: :any,                 arm64_ventura:  "df60af939baefbc036bca27de5be2669758dc2c2864a16178dc4916324a77e01"
    sha256 cellar: :any,                 arm64_monterey: "56f55a4cea81a5014a2939d836ca1586941b0d18f53757de67141eace5005061"
    sha256 cellar: :any,                 sonoma:         "7f67a8fa921b335dcad92ec624006977104e1b19ef5219508e44e65dd7b4560b"
    sha256 cellar: :any,                 ventura:        "2944a3550c8885951dde845bed1bc669413c8e5bfff9ebdb3c76effa603399ef"
    sha256 cellar: :any,                 monterey:       "4820fa07c07203d69451463ac697d213cf1bfef51726b8c66fcc674a78aeda5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6af7fe38c679aa37dff51d886f3eab82f6960d2546d438f1e84c02b79035e082"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "source/river")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/"example-config.toml").write <<~EOS
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    EOS
    system bin/"river", "--validate-configs", "--config-toml", testpath/"example-config.toml"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
