class Shellcheck < Formula
  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "https://www.shellcheck.net/"
  url "https://github.com/koalaman/shellcheck/archive/v0.9.0.tar.gz"
  sha256 "3cec1fec786feee79dacdabf9de784a117b7f82388dbcca97ba56a5c9ff7d148"
  license "GPL-3.0-or-later"
  head "https://github.com/koalaman/shellcheck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bebeffc6b702b0684977937af20bd6dec9241f1f6bb206cf8c002bff76f0ab25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0c8f83c50c5adae71abc074b69932249354869bb7c67161e0a783a11e6004f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d81c9557cec60f65820ac4727dafbd0871276b66038d1c82f8e04ee03ed3df0"
    sha256 cellar: :any_skip_relocation, ventura:        "5eb6e89880dcb5cc6baeff63f6c2453342cee15ec35c525351c2099545ad4d62"
    sha256 cellar: :any_skip_relocation, monterey:       "957348802279e04cba39b7b9d4a3300f1891e73646dcba5ca36a30b15d6e2e6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1513cc886e5117e572a642864edee6882409f9800a57315e9c87d17c52156847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e9e847cc3ad50ae9bdbe9215bfaf9f33836378b54b07b716b25bc66f65a0d23"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
