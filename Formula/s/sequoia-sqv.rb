class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.3.0/sequoia-sqv-v1.3.0.tar.bz2"
  sha256 "cfa9159cbeda4e4d0e3c2778374b24004037bb21d5ea6441f0fb80c68cedfce0"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "845015f993740f9d1698ad2cd74e6b4d6ca5520b230ef79f751c7b16074a4adb"
    sha256 cellar: :any,                 arm64_sequoia: "0d2d0d9d29c1cffd455b11ffc5bc740500af785ab7812c997d83c179c89fc517"
    sha256 cellar: :any,                 arm64_sonoma:  "5485c94b874a9c8a4fd40e946c2e1c43e64db3a9a4a0916bdf04634174313150"
    sha256 cellar: :any,                 sonoma:        "0d605f0ec76c4a4e085be2a7b4d97c74b5afcef2e7fa9b094dfde1b5f79289e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a60d77009dbda5d2a4b93c79c67d2a13a2d3f84e7d1dd099eb620b5b6f7e0e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "232098b16c3f1b096bc2a5e11088baf698f090cec86a43c9be1ab8345cee2191"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
