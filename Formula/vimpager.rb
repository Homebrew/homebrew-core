class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  head "https://github.com/rkitover/vimpager.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2b9ce26d12c155adb0c9e2524b67b7e8e0a41fb75ee524999ec0818ca619659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356c5407fc0656ac0b4ae4a7a3e62f1992525a120a7a1d0b6fdd514561d5381d"
    sha256 cellar: :any_skip_relocation, monterey:       "37620c6662f65c8314c749c26260bafff4645b80877e9f152783d063dcae9283"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ead831c50c50e1b95b18695737936bc907c9241867d3700c87120c8af09aea7"
    sha256 cellar: :any_skip_relocation, catalina:       "2a409da1fc4a31e1165e33ed681ed15b874d514721c7295a0901ebf4516aa469"
    sha256 cellar: :any_skip_relocation, mojave:         "f4ec02de4d30af041e98f3ab4ce6344424f7a8f5bfeca6cf21dc179cbd6e576a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "73aaa39c9876664b2f0b0a98dea30ea34e05504f28d607276873345d57b97834"
    sha256 cellar: :any_skip_relocation, sierra:         "308c68e761983beb317bbefcba285022dbc74a66486a3da7e2ac8bc929649a3a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "eccfe695299ff91b489e0385b2024e6f383426f696dc4a5462fe2e0bc6f875b1"
    sha256 cellar: :any_skip_relocation, yosemite:       "be8ae8e77106e1fa95821b59171b982af74365693be0b416e41bb807a07c6c60"
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
