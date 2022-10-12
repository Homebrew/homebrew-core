class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.15.tar.gz"
  sha256 "0986ac647098b877f24c863c261bfb7cf545a41fd1120047337dfc44812c69a0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "eb8f8ad40b64c81597429af23975a0139e5a694298b07d9490953b99b18dde47"
    sha256 cellar: :any,                 arm64_big_sur:  "adb5286beba7c576529052e28b772307356a6e3810bba69b28293d25af2a7d20"
    sha256 cellar: :any,                 monterey:       "1caaf3acce4bc823da5447ac2b7ebdaf0187e342ce517dee0031952703466ea8"
    sha256 cellar: :any,                 big_sur:        "b528f5d73f4b397ce34b045b5f1afba9d443a34e7793b0d5f5e6af71dfe564df"
    sha256 cellar: :any,                 catalina:       "81a1b69fa2b4059b214d3b3489a4383b3e6a169f712c2cdbe28752ba97a15b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944b95bab55036638b1ef17d1acd7613f6ba7357b080f777ead8e7d9b3d0ee64"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
