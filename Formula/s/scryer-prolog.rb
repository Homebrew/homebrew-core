class ScryerProlog < Formula
  desc "Modern ISO Prolog implementation written mostly in Rust"
  homepage "https://www.scryer.pl"
  url "https://github.com/mthom/scryer-prolog/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "353eca4eea539e0a0eedb1572736bfcc64c5fb6fd2da3b8737c513ad62f60f3b"
  license "BSD-3-Clause"
  head "https://github.com/mthom/scryer-prolog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d48c0a73df9bf67c54bc855ed865155ad79f41a4561591ed3f7359c3e9d2022d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da512766a1a27fe22eb01c1ae6a7c89dd934425d2388d1d482512689fedebd6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b08c3101dbe3c77c75ab5025e9a4d2fc49c2ed1f17a9839d7357d6972db614db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff71107fc21ebf2fad8c3be28b9801f65fba480207d8300af56b8df3975f5c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e3d6f8f168ef2b0bdd2c27755d68f1d6a8133fe9740e52d4914c509fca6e5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549989dbd09c1d6885e73357b5f2ba49e762bcbd3eaa0d35110832b0719db02e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
        write('Hello from Scryer Prolog').
    EOS

    assert_equal "Hello from Scryer Prolog", shell_output("#{bin}/scryer-prolog -g 'test,halt' #{testpath}/test.pl")
  end
end
