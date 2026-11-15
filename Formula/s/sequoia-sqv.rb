class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.5.0/sequoia-sqv-v1.5.0.tar.bz2"
  sha256 "695749c7b8dc006c0d5ade1830bf6263453eff8211d1e18402f6686327124800"
  license "LGPL-2.0-or-later"
  compatibility_version 1
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4901e4a68f1a3041e3289605044783cf056958c4d0ec735f94dd62afb73b99e1"
    sha256 cellar: :any, arm64_tahoe:       "a0be56817a575d08053d42ff37df1662a28cf3e92317b84b8fe85b7d8da9b370"
    sha256 cellar: :any, arm64_sequoia:     "77974f2e835e41c29c22fde6cef4f64fe9a4440c96a474ee90b39bfab2a865ca"
    sha256 cellar: :any, arm64_linux:       "26da1c192176be3d758175dfffc8031a954f3ae43e6641403594cd2c0e516700"
    sha256 cellar: :any, x86_64_linux:      "cb2267d295815a6f88b3c6641ef20c5d09c7f334e4037541784cdf967a190469"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang (bindgen)

  # Test needs to fetch stable tarball
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["ASSET_OUT_DIR"] = buildpath
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl")

    man1.install Dir["man-pages/*.1"]
    bash_completion.install "shell-completions/sqv.bash" => "sqv"
    zsh_completion.install "shell-completions/_sqv"
    fish_completion.install "shell-completions/sqv.fish"
  end

  test do
    # https://gitlab.com/sequoia-pgp/sequoia-sqv/-/blob/main/tests/not-before-after.rs
    keyring = "emmelie-dorothea-dina-samantha-awina-ed25519.pgp"
    sigfile = "a-cypherpunks-manifesto.txt.ed25519.sig"
    testfile = "a-cypherpunks-manifesto.txt"
    stable.stage { testpath.install Dir["tests/data/{#{keyring},#{sigfile},#{testfile}}"] }

    output = shell_output("#{bin}/sqv --keyring #{keyring} #{sigfile} #{testfile}")
    assert_equal "8E8C33FA4626337976D97978069C0C348DD82C19\n", output

    output = shell_output("#{bin}/sqv --keyring #{keyring} --not-before 2018-08-15 #{sigfile} #{testfile} 2>&1", 1)
    assert_match "created before the --not-before date", output
  end
end
