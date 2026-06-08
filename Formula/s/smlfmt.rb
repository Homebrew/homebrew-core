class Smlfmt < Formula
  desc "Custom parser and code formatter for Standard ML"
  homepage "https://github.com/shwestrick/smlfmt"
  url "https://github.com/shwestrick/smlfmt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9d26a87bfba7d49929edf3cbdc060e9a58cd5a5b1367456281aed2e3e267926a"
  license "MIT"
  head "https://github.com/shwestrick/smlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a261ad88d56f8c39d85e62003120fab2d483e2f1a7af2be48e5c8eb7f7224a6"
    sha256 cellar: :any,                 arm64_sequoia: "06620f62039562a032792cdbadaa780edde9700e4c0499e08daac2243fb146f7"
    sha256 cellar: :any,                 arm64_sonoma:  "f24dc78b13263922af685639ff341ae26c1db6721dacdbd71e79fc2c6ddfd518"
    sha256 cellar: :any,                 sonoma:        "3c56a9b0ccf0437cc718ad0e1a91e677398551402d4a672a31b7614bf2faa036"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1e32327ddde900882ec6ee21d13fd810086e8fbd08ad313bf8c0c4f504b48b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8693b806e6d7ff754d15bcb36caa3166ec181c384928b720220551a3213ecc"
  end

  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    system "make"
    bin.install "smlfmt"
  end

  test do
    (testpath/"source.sml").write <<~EOS
      fun foo x =     10
      val x = 5 val y = 6
    EOS
    expected_output = <<~EOS
      fun foo x = 10
      val x = 5
      val y = 6
    EOS
    system bin/"smlfmt", "--force", "source.sml"
    assert_equal expected_output, (testpath/"source.sml").read
  end
end
