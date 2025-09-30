class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "https://tools.suckless.org/sic/"
  url "https://dl.suckless.org/tools/sic-1.3.tar.gz"
  sha256 "30478fab3ebc75f2eb5d08cbb5b2fedcaf489116e75a2dd7197e3e9c733d65d2"
  license "MIT"
  head "https://git.suckless.org/sic/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?sic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7d152ce0d8b3a19197f66e697c611d405ce241c2bc5a05cd48dafbc9e358e381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f028ab4b890ec81ff5bf82098d31f3f805d3a9efed26328bc83fc3929980af92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "181b20a9474e97e9650248f715220259b3716ee65258beb6e511d9513fd7d752"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c210a33d10989dd50a31cabeee9e2a560befb330f79e13a0a561a7be515cbae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8b5bc082f2ee0489f175edb22dd2c8e3128f584f9f6ee7777f852d90340644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d028cc40c4c63b26365753fbdb90d0d8880fa5114b88af26fbdb4570faacf019"
    sha256 cellar: :any_skip_relocation, sonoma:         "41f60a36d36c43f83fad82d79477d1d59b34ae634e503d91c855a95241a58fa5"
    sha256 cellar: :any_skip_relocation, ventura:        "c82a6f606d883c125acc102b457fa5e38d1475665f5c99e1715840cd6f00edd5"
    sha256 cellar: :any_skip_relocation, monterey:       "996dcadfff9c9eb20d7a45ef0a796ab28420d2d90aecb81a69566de271798967"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2b8f0304692bb2bc7442affab89105413028b7ebcb0a2b7e6504518ef0bc5ed"
    sha256 cellar: :any_skip_relocation, catalina:       "f61b9190993e7ba1f4d4e5b98f751db0965a7bb72db8023e5f8ebf272568540a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d7904a3996132de7d25f87b6872a0d572d92612e551697b52d68b9940120b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa93fbe3a3e4ed400bfdad52b0ba893161505e7579e5c1731a9f28a7e993f59a"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
