class ScryerProlog < Formula
  desc "Modern ISO Prolog implementation written mostly in Rust"
  homepage "https://www.scryer.pl"
  url "https://github.com/mthom/scryer-prolog/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "ccf533c5c34ee7efbf9c702dbffea21ba1c837144c3592a9e97c515abd4d6904"
  license "BSD-3-Clause"
  head "https://github.com/mthom/scryer-prolog.git", branch: "master"

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
