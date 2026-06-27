class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.4.0/sequoia-sqv-v1.4.0.tar.bz2"
  sha256 "1b004c7cbd3aa5ec39b445ea19eb8034111d668e92d1aab277a582e39101912c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "807814eeb81d9bdbe053a31cf89199cfbf7a36745e02d6be609c08badf518d82"
    sha256 cellar: :any, arm64_sequoia: "f77ee331dcfe528b3545aaafce5d7ce41b0eb828e4dd224ccc6c61a38a9a62de"
    sha256 cellar: :any, arm64_sonoma:  "ffbcadde00ca7cbdc5330f7427856b94685f5aee346a27fef9ec5126e43a7b7b"
    sha256 cellar: :any, sonoma:        "ca50c9284101d204624a7845c495ab12d84ca73d2a905dfb11b031bd55ad4aab"
    sha256 cellar: :any, arm64_linux:   "6bc4a2287399fc83b1e6654351ee825eaa5373621b8c434c4c7422dc83d06c83"
    sha256 cellar: :any, x86_64_linux:  "0b241d5fc0a187a34016ec7fd5bf0c390176945cf2a6c831b0da67d7c06b409a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
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
