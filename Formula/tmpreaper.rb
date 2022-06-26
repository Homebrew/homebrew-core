class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.16.tar.gz"
  mirror "https://fossies.org/linux/misc/tmpreaper_1.6.16.tar.gz"
  sha256 "e543acdd55bb50102c42015e6d399e8abb36ad818cbd3ca6cb1c905b5781e202"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f4f03eff7847b9b95990d19a92ce37a4c713526e9f8bc757499f87e4403d114"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b42c830efc19dd09b2c329d20512521bf32a050faaccd4a959b51cc63fd0273"
    sha256 cellar: :any_skip_relocation, monterey:       "fd319cab825b31c8009633fa518762e94e1f37cd8930aee53506aa61ebcd40bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8252d7a640ef1e750723d91308cec36a281e04179ab119ec454164afca8a378"
    sha256 cellar: :any_skip_relocation, catalina:       "484c58aff60e28e698cd6e04cac1974a75316d2fce0028f78b4b720c443a27f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f437e1f006c0a44a6e6c92b7de0f932d63cdadd32bc07f5f1866163632c60a3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "e2fsprogs"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_predicate testpath/"removed", :exist?
    assert_predicate testpath/"not-removed", :exist?
  end
end
