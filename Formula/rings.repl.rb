class RingsRepl < Formula
  desc "Rings: efficient Java/Scala library for polynomial rings"
  homepage "http://ringsalgebra.io/"
  url "https://raw.githubusercontent.com/PoslavskySV/rings/v.2.0.1/rings.repl/rings.repl", :using => :nounzip
  sha256 "fe3fc145deb1750160c0a9b6098ea80a92ec0a841304b94da1af0e94143b1c00"

  depends_on "ammonite-repl"

  def install
    bin.install "rings.repl"
  end

  test do
    system "#{bin}/rings.repl", "-v"
  end
end
