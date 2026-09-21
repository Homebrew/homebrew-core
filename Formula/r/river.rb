class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https://www.memorysafety.org/initiative/reverse-proxy/"
  url "https://github.com/memorysafety/river/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fe96d3693d60be06d0d1810954835f79139495b890b597f42c2b0bfa2bd8c7a6"
  license "Apache-2.0"
  head "https://github.com/memorysafety/river.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b896b62e95e6f88c62316934c0da8103750b83c555292d183356ecbc660db4c4"
    sha256 cellar: :any, arm64_tahoe:       "65ca2b30775f9a010cd7a2fc8408581a596295de3ebc12a5060451a949f6499f"
    sha256 cellar: :any, arm64_sequoia:     "390f6ec9178f51e8b0998a05676eec457da45c894c1175c16f98fdac88c979ce"
    sha256 cellar: :any, arm64_sonoma:      "e034913a46c445d4c1e63c34b5479ac4601e37dc4af3ac2931ffe226f597fac0"
    sha256 cellar: :any, arm64_linux:       "1d166f0942c670c915542ce1dd7ccb17ec6fff21a61caed0825cecbc94bfaa2a"
    sha256 cellar: :any, x86_64_linux:      "7f89656a962554f6248a9ae9850b8ebb6ae87209b20e2b5e563c268efc76d439"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  # `pandora-web-server` moved off GitHub, so the pinned git dependency 404s
  patch do
    url "https://github.com/memorysafety/river/commit/d7de7566ab1cccb3a8c46c609e9ae5d511a9b0ae.patch?full_index=1"
    sha256 "23626140f673e189fa67145eb6c25e205536ecdddd784a03836b8da3577ae718"
    type :unofficial
    resolves "https://github.com/memorysafety/river/pull/92"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args(path: "source/river")
  end

  test do
    require "utils/linkage"

    (testpath/"example-config.toml").write <<~TOML
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    TOML
    system bin/"river", "--validate-configs", "--config-toml", testpath/"example-config.toml"

    [
      formula_opt_lib("openssl@3")/shared_library("libssl"),
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
