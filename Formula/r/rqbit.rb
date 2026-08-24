class Rqbit < Formula
  desc "Fast command-line bittorrent client and server"
  homepage "https://github.com/ikatson/rqbit"
  url "https://github.com/ikatson/rqbit/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "62a42c56259b737eea6580b63061589dc9940b145c40991cfff83470aa783291"
  license "Apache-2.0"
  head "https://github.com/ikatson/rqbit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dca7d2cd2f280e9faf40def0976b4af3376ccf0fa55a97542825fbb92b22d14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e2f6c877977e8cf35fe3d594b2765f1c32e74574b5e93df44f59519cc787427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5140af1afa446f83e16b442e21b4c8e7c2719978ab93d277594e0fffef3c030f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ddf1439b0d0d2c817e05e56783995efc31b2a82eab0cfe3eb20e5d2996fec6"
    sha256 cellar: :any,                 arm64_linux:   "68a70796b2f168200ea6f0f819a83c00978304ccc6c435453bb26582df07b1e9"
    sha256 cellar: :any,                 x86_64_linux:  "19cf681f97b552aff7540b3c156264c59329182dbbb3d4fa0d3f74c168608188"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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
        formula_opt_lib("openssl@3")/shared_library("libssl"),
        formula_opt_lib("openssl@3")/shared_library("libcrypto"),
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
    assert_match "File archlinux-2017.02.01-dual.iso, size 870.0Mi", output
  end
end
