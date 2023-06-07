class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.9.tar.xz"
  sha256 "831f1671e737bed31de3721b861f3796461ebf3b05270cf4c938749120ca8e5b"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/shmcat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f501e817599e1da0c0d0edb51931113b58c43b98fca00fb207a8213fc1418d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e280843c7f422bacd40e5785236613d1a82e712405b6fa68910b6dee91946b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bdee0944414bc51a08a7707e29d16a6f08e1d583ad4cd8357587da2a6519d05"
    sha256 cellar: :any_skip_relocation, ventura:        "fc03e13384a073b4d96f13a7d8fb204e42cf0041d7d6a4c07e09fee21272d5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc928ec60a7a9af5404195a4f82cc87d51a60f1292c1611b59401cc226fb39f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a7b108892ada071d5ce75b8eb434b9c77c6cea5ed767ce31c78ac6e4b90d540"
    sha256 cellar: :any_skip_relocation, catalina:       "f86090c36d839092913667dcfc924f76c71d318a03434a1e608b3960b1df7807"
    sha256 cellar: :any_skip_relocation, mojave:         "e052a4f6b21407c032c1ee5a79fe9b1c08e78b7980c1cd3d6bfbfa8ffe639a58"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ff73e6df8b663b4f382098ce75a9ec4634d4658c5378b3ad122de135e30d44ab"
    sha256 cellar: :any_skip_relocation, sierra:         "5ee7bcafe69d653421e29b56cf2e48a55874dc1e092e817a83cb446cda4acf01"
    sha256 cellar: :any_skip_relocation, el_capitan:     "1b6ddaf528253df2e2d5b93e97b6f4ade717ff8f3f6bcf829ed7cf9d9e682539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb601cd0dfebcb5b7633bf1e8610ba8b1a3858b67feb9848020a3ad1152e780"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-ftok",
                          "--disable-nls"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shmcat --version")
  end
end
