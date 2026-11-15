class Rqbit < Formula
  desc "Fast command-line bittorrent client and server"
  homepage "https://github.com/ikatson/rqbit"
  url "https://github.com/ikatson/rqbit/archive/refs/tags/v9.1.0.tar.gz"
  sha256 "5bf15132fa6f7395ea94c7428d53070aaf72f2adb9b5387c27ecd496830abfb3"
  license "Apache-2.0"
  head "https://github.com/ikatson/rqbit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5424d8dcaa06035c2ef8c61741a4cf5cfbb152c70322bae916cb812b7ccb599f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfc65b9a5980ce607c476dc6171f4207097d5b74f46420afec2d242ba9cd95a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a86b8a4944c47bc763a08be24610270f83a1d8c450b2845efd096c4143b37dea"
    sha256 cellar: :any,                 arm64_linux:       "5915cad2671dc54512c556af877ee9296a3b7f4d1ceb499f1dde223a932f7f12"
    sha256 cellar: :any,                 x86_64_linux:      "15ee248b2a00d7b1d952d053dd82d2f0529c9e0122184d0e542cfc7b629e23ee"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "crates/librqbit/webui" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    # Ensure the declared `openssl@4` dependency will be picked up.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

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
        formula_opt_lib("openssl@4")/shared_library("libssl"),
        formula_opt_lib("openssl@4")/shared_library("libcrypto"),
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
