class Rdrview < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://github.com/eafer/rdrview"
  url "https://github.com/eafer/rdrview/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "e83266cb2e3b16a42f3433101d1f312350ce1442561eaded67efb51c2e8e8aab"
  license "Apache-2.0"

  depends_on "pkgconf" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      On macOS, rdrview does not currently implement a sandbox upstream.
      Use the --disable-sandbox flag if you choose to run it:

        rdrview --disable-sandbox URL

      (Only do this if you understand the risk.)
    EOS
  end

  test do
    output = shell_output("#{bin}/rdrview --help 2>&1", 1)
    assert_match "usage:", output.downcase
  end
end
