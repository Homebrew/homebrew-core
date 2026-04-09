class SequoiaSqv < Formula
  desc "Simple OpenPGP signature verification program"
  homepage "https://sequoia-pgp.org/"
  url "https://gitlab.com/sequoia-pgp/sequoia-sqv/-/archive/v1.3.0/sequoia-sqv-v1.3.0.tar.bz2"
  sha256 "cfa9159cbeda4e4d0e3c2778374b24004037bb21d5ea6441f0fb80c68cedfce0"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sqv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "568055ffe201b99282b0109f992799923d0b7ddb91d07a8b4f316ebeb22f4fc0"
    sha256 cellar: :any,                 arm64_sequoia: "5e55783ed124a3414dabd9e6621462b146b6056f195c89295ae63fbda89e6cd5"
    sha256 cellar: :any,                 arm64_sonoma:  "a9b453a25fbeddfc5705d07fba41b082709c3b26727f72c9db0960ec6ec2bb54"
    sha256 cellar: :any,                 arm64_ventura: "fb6f4007a7cc381ee7fc39150cc08000b3c4b0d6c61ab5f771840d15522f5abb"
    sha256 cellar: :any,                 sonoma:        "cac0ede5fd6bd2543a994cf67d8a48dfb76de9c1a0ae922655decdd47db2b924"
    sha256 cellar: :any,                 ventura:       "bca9e265980a5e1d492157f174a32c7c0264799ccc7dd121456924eebc6850b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436baddd5f72daf501ea4c966dac93f4ef811a0af1c6a933fcbab808afd34711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6929e0826397eb7eb9ac89cbb5c431a7b0fb561d968ac9402fe4385831be52b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"

  uses_from_macos "llvm" => :build

  def install
    ENV["ASSET_OUT_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

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
