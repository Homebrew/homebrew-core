class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.1.tar.gz"
  sha256 "f41ef307b0b9c7424398813b9c6e39d37a970831071e301842ba4b1145d56278"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5dfafe17a1c3ec0d9ff8f13c36a17e8ddc7ce6ed55a1df78514f60a37dd477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acccbd91c0a28354e0e5cfa448b84e65b56cdc3183037608d88426ce42361b42"
    sha256 cellar: :any_skip_relocation, monterey:       "0f362875cf63d6ab25b4ab0bf487d20ba08485a0680e66cedbcadd154902dc22"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ee61ba4a007adce01bfe9d70b025770ba444b016a40271241db9a86f82ef505"
    sha256 cellar: :any_skip_relocation, catalina:       "095b74d3cbad466cf63f40b1fb26face89ea2e9046d377fb8fc5e05eb9293012"
    sha256 cellar: :any_skip_relocation, mojave:         "ced31018d86983a844fd5a4d0ba2f0b390ba78b4c9840c0f1a2f8cddfd4242b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc1df082506d11046c1684da356951de0d79e59bbb9ace04a2c221647117787"
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
