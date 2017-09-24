class Taylor < Formula
  desc "Measure Swift code metrics and get reports in Xcode and Jenkins."
  homepage "https://github.com/yopeso/Taylor/"
  url "https://github.com/yopeso/Taylor/archive/0.2.3.tar.gz"
  sha256 "027c7e98d752ad57d2714a1c148d2b044d91a33ced18cd1bf2d82a020788bdd2"
  head "https://github.com/yopeso/Taylor.git"

  bottle do
    cellar :any
    sha256 "e965985520ce326c12d7d07da359b075018d48b79d1d2b044db68586bafee551" => :high_sierra
    sha256 "fda9d12ec890daca148dd5819dfe5e61750b30b677031d035129dcf226a8fe84" => :sierra
  end

  depends_on :xcode => ["9.0"]

  def install
    system "make", "install", "PREFIX=#{prefix}", "MAKE_SYMLINKS=no"
  end

  test do
    # Improve test once sandbox issues have been resolved:
    # https://github.com/Homebrew/legacy-homebrew/pull/50211
    assert_match version.to_s, shell_output("#{bin}/taylor --version")
  end
end
