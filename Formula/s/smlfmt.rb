class Smlfmt < Formula
  desc "Custom parser and code formatter for Standard ML"
  homepage "https://github.com/shwestrick/smlfmt"
  url "https://github.com/shwestrick/smlfmt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cbbdfbcf1f929c6e933a2e4f7a562bf71b0709ca9cd2888bf58a53c4ac0240e5"
  license "MIT"
  head "https://github.com/shwestrick/smlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1bd2a194676f77170769c94b4202571282b9120b207fea0f9ab918065586c27b"
    sha256 cellar: :any,                 arm64_ventura:  "3e7920a121398c2b18d065bb0a36f2e86db8443888f1b5a0b63fb088e323767b"
    sha256 cellar: :any,                 arm64_monterey: "93c73fa1847999f8e9623244f422db8c08f185fe416b8937f55d524cb54793d1"
    sha256 cellar: :any,                 sonoma:         "ef51e9b376793682192313b74f45100b598abb377a553b1e51c8bd8b9391fc83"
    sha256 cellar: :any,                 ventura:        "812942077d36a625b66b4193dfd3d4452bee0459518f5e6508e54263711f1e5f"
    sha256 cellar: :any,                 monterey:       "5669c96246d4621e7d9f3000df96bac67b7d5c77acc85b92b013a3b9457ed70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5fb6d02d84f4819ae99f6049dd399771d14a746fdce712cca5e6d4c290ef38"
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
    system "#{bin}/smlfmt", "--force", "source.sml"
    assert_equal expected_output, (testpath/"source.sml").read
  end
end
