class Verovio < Formula
  desc "Command-line MEI music notation engraver"
  homepage "https://www.verovio.org"
  url "https://github.com/rism-digital/verovio/archive/refs/tags/version-5.3.2.tar.gz"
  sha256 "01e1fc919dbfc1db7f61612057a91257b9e6ac3dfec980b26f779cffbbadbbf6"
  license "LGPL-3.0-only"
  head "https://github.com/rism-digital/verovio.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "8f6efd1914dc7db0c0eefdf1d7171648b2fe33901a9ae81b94d400438c5811f3"
    sha256 arm64_sonoma:  "7fbde86cc3ceed5bca9e5faa4384ddb2edac9b36c198cb2c996eff499a92f2ee"
    sha256 arm64_ventura: "054f95ad544a83570ea94ed46455491ad997f7f160cd1baf281c51ae4399fbd5"
    sha256 sonoma:        "4be1fe0782be774985f5271539d8a81376c737e457c1d3b8e0829fde06747f7d"
    sha256 ventura:       "bef859db9b18f9052c8d24f7c3bd25e61f579345d4a5b3201715f6ea2a4f2d45"
    sha256 arm64_linux:   "90ee04d6a8ef5607cfd0c1a68c65228be812f405289850d93c35033ca3882bd1"
    sha256 x86_64_linux:  "2b623c69c0ca6bbf8be88fc4a0088249a64194e3268b3f874ca981af755809f1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "./cmake", "-B", "tools", *std_cmake_args
    system "cmake", "--build", "tools"
    system "cmake", "--install", "tools"
  end

  test do
    resource "homebrew-testdata" do
      url "https://www.verovio.org/examples/downloads/Ahle_Jesu_meines_Herzens_Freud.mei"
      sha256 "79e6e062f7f0300e8f0f4364c4661835a0baffc3c1468504a555a5b3f9777cc9"
    end

    system bin/"verovio", "--version"
    resource("homebrew-testdata").stage do
      shell_output("#{bin}/verovio Ahle_Jesu_meines_Herzens_Freud.mei -o #{testpath}/output.svg")
    end
    assert_path_exists testpath/"output.svg"
  end
end
