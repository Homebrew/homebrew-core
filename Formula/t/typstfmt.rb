class Typstfmt < Formula
  desc "Formatter for the Typst language"
  homepage "https://github.com/astrale-sharp/typstfmt"
  url "https://github.com/astrale-sharp/typstfmt/archive/refs/tags/0.2.7.tar.gz"
  sha256 "17db7ddb83a8e2e43b3b34f19dcc8cbd3585aea34e05a5689e6f5beda27ac523"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"whatever.typ").write <<~EOS
      #rectangle[
      test
      ]
    EOS
    output = <<~EOS
      #rectangle[
        test
      ]
    EOS
    assert_equal output, shell_output("#{bin}/typstfmt #{testpath}/whatever.typ -o -")
  end
end
