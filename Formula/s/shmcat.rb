class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.9.tar.xz"
  sha256 "831f1671e737bed31de3721b861f3796461ebf3b05270cf4c938749120ca8e5b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/shmcat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d2215296ac7593c43a7ae9fb164cff3b11804dc7c0ec1b20af35397701a3b2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "103cda477b51d8e4ef25053b80346b9c7e433ef5db2c3f9efc21e815faf1556b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9249f70d6b9d337e959051cc23417d12fda97e704d53ae4cd1be561f9541fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f501e817599e1da0c0d0edb51931113b58c43b98fca00fb207a8213fc1418d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37e280843c7f422bacd40e5785236613d1a82e712405b6fa68910b6dee91946b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bdee0944414bc51a08a7707e29d16a6f08e1d583ad4cd8357587da2a6519d05"
    sha256 cellar: :any_skip_relocation, sonoma:         "406f35b9aa4941ea2324ae88feb143a0591442bcf0f5c66d7a85e2bfa9ca52d7"
    sha256 cellar: :any_skip_relocation, ventura:        "fc03e13384a073b4d96f13a7d8fb204e42cf0041d7d6a4c07e09fee21272d5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "dc928ec60a7a9af5404195a4f82cc87d51a60f1292c1611b59401cc226fb39f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a7b108892ada071d5ce75b8eb434b9c77c6cea5ed767ce31c78ac6e4b90d540"
    sha256 cellar: :any_skip_relocation, catalina:       "f86090c36d839092913667dcfc924f76c71d318a03434a1e608b3960b1df7807"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "08d6b2ad911eb82d4426537e8958ea7e8e8fe408fa3c9041dde2a14f710b9dfe"
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
