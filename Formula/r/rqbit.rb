class Rqbit < Formula
  desc "Fast command-line bittorrent client and server"
  homepage "https://github.com/ikatson/rqbit"
  url "https://github.com/ikatson/rqbit/archive/refs/tags/v8.1.1.tar.gz"
  sha256 "452b8260fabba938567e1819a9edfcf6b69579ecd5f8b87fee4ca1666fa8fede"
  license "Apache-2.0"
  head "https://github.com/ikatson/rqbit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e67ea2e32ddb0dfa94f7f369f5067e4b87d4ba989942e5a1eabc150fe6992d63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e638e63d0887e92e07f9269a0780efc424b129c2c6c77defeeb475815733b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abde32ab711dfb6e35b4820298f253cde4f4a3d7f1004b269dccff61869754ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "535aff6ec35570430fd0c2cf2032a1beffc33b381855e5ebb4a4946e343cab43"
    sha256 cellar: :any_skip_relocation, sonoma:        "0738b342798a9e02ce8e754e5bec29167e05bffe04c3877e4ab90111ef58488a"
    sha256 cellar: :any_skip_relocation, ventura:       "5e46d0d0d6ddec3d97d0ff3aee5ce554439edc45f009e9f3646c6df2633a3de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc58d1f39c3788a5b19b90a18a8735ffaa1cc8b0478c43c39a4ed5f07dcc68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6392ea3522c23a0c05d5fffb972545fbbd38a32eee31883f64a4e59d87970580"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure the declared `openssl@3` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/rqbit")

    generate_completions_from_executable(bin/"rqbit", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rqbit --version")

    # NOTE: rqbit uses the `native-tls` crate which uses the system Secure
    # Transport on macOS so it will only link to libssl and libcrypto on Linux
    if OS.linux?
      require "utils/linkage"
      [
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      ].each do |library|
        assert Utils.binary_linked_to_library?(bin/"rqbit", library),
               "No linkage with #{library.basename}! Cargo is likely using a vendored version."
      end
    end

    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=https://tracker.archlinux.org:443/announce
    EOS

    output = shell_output("#{bin}/rqbit download --list --output-folder #{testpath} '#{magnet_uri}'")
    assert_match " File \"archlinux-2017.02.01-dual.iso\", size 870.0Mi", output
  end
end
