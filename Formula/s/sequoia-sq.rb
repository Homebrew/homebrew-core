class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v1.3.1/sequoia-sq-v1.3.1.tar.gz"
  sha256 "9f112096f413e195ec737c81abb5649604f16e1f6dbe64a8accc5bb3ad39e239"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af93f1cb2fa3295751c7789f2e19cb799036aa31f6574399cd4335452b92e8a0"
    sha256 cellar: :any,                 arm64_sequoia: "748da0543b832cadfa5607c47bd93938bb09a31447ba6470bed0eecd9eed5abe"
    sha256 cellar: :any,                 arm64_sonoma:  "3de29e0d109f761a2354bb4b2ca540c430f11f402616453c6e01d6f936a1df41"
    sha256 cellar: :any,                 arm64_ventura: "c5877c6019980cb390b99241687b16e6ab4b41dc8eb1472d3a7654c6cac966c2"
    sha256 cellar: :any,                 sonoma:        "6b3a8b05eca43acd239476880e5515cc75b283173a0226c7568e5ba84fcc7e14"
    sha256 cellar: :any,                 ventura:       "f45c40f7187c727f4ab15f925d02125cedb72cc50227f2c30a1bb540adf1ca28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cc134524aab57fd7d7e15586e4410b1081998bf03a2dd7b7393044b8729a30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bdca043f7be55ffe5682aacbc18863cf02eb7fbb698f176e7a880de304cc1da"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "gmp"
  depends_on "nettle"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash" => "sq"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")

    output = pipe_output("#{bin}/sq packet armor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end
