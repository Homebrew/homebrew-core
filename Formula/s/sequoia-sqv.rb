class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.5.0/sequoia-sqv-v1.5.0.tar.bz2"
  sha256 "695749c7b8dc006c0d5ade1830bf6263453eff8211d1e18402f6686327124800"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3ea889ab5ab37e22d8f432bfbe0057d0e01e89659995f514bd0a118af31495b1"
    sha256 cellar: :any, arm64_sequoia: "87912a68b3dd4307bcf61b2af41679a248b91cd39f6bb050bd347a298d66e805"
    sha256 cellar: :any, arm64_sonoma:  "f56d097deb461baf37bedacd0b2afb0ee23ba8f4d1229b12a7dbdf7fc164a04b"
    sha256 cellar: :any, sonoma:        "2fcddfb42c6c83daa1f0d845c35084926507b8ccdedd9c7689a5079dd16e2cd5"
    sha256 cellar: :any, arm64_linux:   "8ae453705f3a164ce38fd8733a857d770b16e8ae2b28aaf3d075df988b586652"
    sha256 cellar: :any, x86_64_linux:  "d5eb5a4f73054fb8d4f215ba3767d87adc351394e832d8cab10ac9fb68bfb6d1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang (bindgen)

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
