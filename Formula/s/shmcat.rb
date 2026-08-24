class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "https://shmcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.10.tar.xz"
  sha256 "821212924bf9ef3fbd7a357b4f1065898c12635b86fa5d7bad259533d251076e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/shmcat[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24cab1a879fd6393b619d8ce55dc53d44a0c6904407e3b4ab019a35c5a9e71ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b757e03b867f96daec5e0ea37feea323c860f72d0f42a08e3c791acfa48eb84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c2be3dfc01ab485e1ace4b7d48630fd92e1c28ca7db55e7e397e049ac34d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b4e00c9ecb0f46f7a66a9228d4a59cc0f2baf760b8135eb5d682872766ac4e"
    sha256 cellar: :any,                 arm64_linux:   "cbcb3afa59ff299acbdf239e00061c3a4a825605519f2766e67a712fe47eefb2"
    sha256 cellar: :any,                 x86_64_linux:  "3b13cb57ab14e269ece886119d76470e54a64328bf164f3500f61d0a48e36b97"
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
