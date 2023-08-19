class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"
  license "BSD-3-Clause"

  livecheck do
    url "https://redmine.lighttpd.net/projects/spawn-fcgi/news"
    regex(/href=.*?spawn-fcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56eaf8799a8a03bec6c678f53cf48aa3b9828a473479150a67a2a58399cc3613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9efa91b0b383106235bc16d9fad9852f33233eb6b81891109b60733ec40ec71c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89bc1faf59756165a4a27cd43fdbac4c5d81ba5e12613fc1152c181a60f5c0df"
    sha256 cellar: :any_skip_relocation, ventura:        "16b2c04a3bca92100db5fe04d56741257daccd7f91737526af4ac45c5805167b"
    sha256 cellar: :any_skip_relocation, monterey:       "d45cd6391796628d9bc7e6c6259150d763f9ab1dcef898f1901359b6e1844f8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c10df486a01421d25bf7ffa44e42f4cc0c14a4fe4c81b6de1eaaf498bcabd1"
    sha256 cellar: :any_skip_relocation, catalina:       "a0665cd25e441b8f798073125e2f4151588aed54408b17f894e62a353ca73d47"
    sha256 cellar: :any_skip_relocation, mojave:         "2512789a14b629470c684a4694e7f26fb28a9734b156f0756279bc8f40c2f2bd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "31c9d255c30ac65009b0972c7b9fe8a8835f8c305800c1b147471b44113fd285"
    sha256 cellar: :any_skip_relocation, sierra:         "23140d56da75279d033d123b5cc5a7d50018dd08e6c74e3ed118eac5adbac555"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4e6f999ebcad8b7ce84473379b6358ec569559f9e4b772d31ef1a5b0e01fc865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0298a54805a7a33df96d41668d628b3c062700328e5e40be7f745092fb3d3077"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spawn-fcgi", "--version"
  end
end
