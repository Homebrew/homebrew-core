class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/bodo-run/yek"
  url "https://github.com/bodo-run/yek/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "ecbdf29ba2955fc33c4e43b3177577a08b05435523b1849924ec10605d2632bf"
  license "MIT"
  head "https://github.com/bodo-run/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac829ae377e2e7b82f3bc006de4466d2d772d3f9acbe78c4af3b69cd5ce59972"
    sha256 cellar: :any,                 arm64_sequoia: "855b82000b222556ebcfe76a601a01947556d00d02cbd6174284ac428dd83af1"
    sha256 cellar: :any,                 arm64_sonoma:  "16ad7af378996899494b182ca0dfa80b208c9d74e91518eceaddad2f602996f1"
    sha256 cellar: :any,                 sonoma:        "ead185f22c47d3c306f5c3caee1f8d8a495d68ac2fa4d82d2e67c4283c4611b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8475649002f88a15bac8a83587e8e704d5e5a657de823886f6b46727c2a61a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92e9ac6bee5dff5a363d8e19c6973a335381ee65a999612094d9adcc844ec5a5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end
