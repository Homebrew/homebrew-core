class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://github.com/anders/pwgen/"
  url "https://github.com/anders/pwgen/archive/refs/tags/1.5.tar.gz"
  sha256 "e1f1d575638f216c82c2d1e9b52181d1d43fd05e7169db1d6f9f5d8a2247b475"
  license "Zlib"
  head "https://github.com/anders/pwgen.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "02488155f0876824620ee9745fb8bd4d6b89fae828bfc0926aebc7f422647a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b97cc880e036c31a7f53592df3eeecd8965645fafff19d1957bfdbfc2b35a45a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38d7fb2634658ff623e2a50d1b8b180ca70f05438d3f4a239ed7fd365b789158"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83a40b37e9b699a826dbce9aa41bba8139766d5020d85b2db736e14106a7fcd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c119ad50fcbce8f68e38f4ed3726c03b34b1df46e9b9ecfd510650cec5d62c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f425de9f8e3e82e24a4c10143e54006c96e6063a19fb64643ec0b3ce279cdaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "76ee29b2b3a28c90a818780c4eadc30c054aead4485a718283e93112bea42c61"
    sha256 cellar: :any_skip_relocation, ventura:        "bb798ef11bc8e1332a175ba210829ed204521942c7269286ed2abb8ab1451f35"
    sha256 cellar: :any_skip_relocation, monterey:       "e2b26cb28d13762f2160eafa1efcec67aa058bfaffc52265b6c546987cf371dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcf403285094f1c803d9f8884aff19225ea5d7ab45329d6efc232f468e43b4c2"
    sha256 cellar: :any_skip_relocation, catalina:       "0fc934513e71330c48333b6e0698b39013d1b2aee57f93124c0c1bff2236475e"
  end

  depends_on :macos

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
