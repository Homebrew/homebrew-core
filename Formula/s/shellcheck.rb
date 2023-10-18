class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.9.0.tar.gz"
  sha256 "3cec1fec786feee79dacdabf9de784a117b7f82388dbcca97ba56a5c9ff7d148"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0688df1adf51536205cde96e4910b26c88b10eb2f967a8255c726f9d0cb57d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ac0d4c4c44a3fd85a52caa0d655c32f28e609713530ba69a52d182b61351e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9fc87309f3997d443d5a5e2c6ec72f3586cbeecdeb002f52f64414f106110e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec4133905b1115275e6ce2d9cd5ef966cbac0e5912fc32e3c89356922ea0ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "89d1c2a187c42d41e99856895989e2bf57a9f82e8a0265dd30d3f417baf273dd"
    sha256 cellar: :any_skip_relocation, monterey:       "f1506e3dfd48ac61184f37b5b6cb48328018bc37e415f78dd4348d2730ad9cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0f7c834a0266325e8dab25a04aeadc67664701b767d3ed2529286fb0fb66823"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
  depends_on "pandoc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    system "./manpage"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<~EOS
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert_match "[SC2045]", shell_output("#{bin}/shellcheck -f gcc #{sh}", 1)
  end
end
