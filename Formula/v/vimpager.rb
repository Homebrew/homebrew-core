class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/refs/tags/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  license "BSD-2-Clause"
  head "https://github.com/rkitover/vimpager.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e3063e707ee99bf0930d116200bc09709807c0bd69ce7f9d69ba8f147c95ca35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f2a6dd688af38e4777f82795806da5477f9bbc91f05f1bb567777656169652a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b414a1f47556bd96038f4314fdcc4a5794c7064990e2b464c951717043c7c0c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd379bf4e911d29607becd56bc99a4d3c0c5fafaa5bcf422c7df37e5dc9ec2bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b9ce26d12c155adb0c9e2524b67b7e8e0a41fb75ee524999ec0818ca619659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356c5407fc0656ac0b4ae4a7a3e62f1992525a120a7a1d0b6fdd514561d5381d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f8a31227e01c9e95ee0fee475942de77686f3ea1b24fdb6fe518c5f4fc551b7"
    sha256 cellar: :any_skip_relocation, ventura:        "c37538249a0c974631d1b6b09d7dcb434a7cca9a9453d2c273ac23c0196932d1"
    sha256 cellar: :any_skip_relocation, monterey:       "37620c6662f65c8314c749c26260bafff4645b80877e9f152783d063dcae9283"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ead831c50c50e1b95b18695737936bc907c9241867d3700c87120c8af09aea7"
    sha256 cellar: :any_skip_relocation, catalina:       "2a409da1fc4a31e1165e33ed681ed15b874d514721c7295a0901ebf4516aa469"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "88731e26d05f8af78003b1fd55a7e19bb8c1bc3e1475ff4a5e995d459158acaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305b43fcc4537a7e89d1a30aef599be641925cb68fe6f87de8216e9cec4391ad"
  end

  depends_on "pandoc" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
    system "make", "docs"
  end

  def caveats
    <<~EOS
      To use vimpager as your default pager, add `export PAGER=vimpager` to your
      shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/vimcat test.txt"))
  end
end
