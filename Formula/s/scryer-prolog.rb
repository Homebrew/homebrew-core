class ScryerProlog < Formula
  desc "Modern ISO Prolog implementation written mostly in Rust"
  homepage "https://www.scryer.pl"
  url "https://github.com/mthom/scryer-prolog/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "ccf533c5c34ee7efbf9c702dbffea21ba1c837144c3592a9e97c515abd4d6904"
  license "BSD-3-Clause"
  head "https://github.com/mthom/scryer-prolog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9e835b97c19a21a9e951a9cb4f3e63b2df085d146a45e1a83fcd6f7c2e2e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a56ddd4c07ac2d2b7efaa3d425e8372164d177ae2051716004fe690c4581788"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0384d324b743441527508b58a077149303dd2dd96a5503c369408f9719cc5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e024f19ee8e58837198cd389c3b7c480ba7c5e387d0857f4922661a79e7c18"
    sha256 cellar: :any_skip_relocation, ventura:       "ca1a6421cda477896165eb0565e298dee3d6a8cbda834b96319d8ecfae1d3b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3568e4dbd9505bd8bb67952b815e18631d464d1608295e9d699b91669533fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440649067671da13802d98cdcd24d605c6eec246d55b3be4b8cb90c612ee7854"
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
