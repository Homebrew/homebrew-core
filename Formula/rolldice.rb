class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/v1.16.tar.gz"
  sha256 "8bc82b26c418453ef0fe79b43a094641e7a76dae406032423a2f0fb270930775"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fa79795244358b512e08fddb6cc86a27029ce8f14038130ab7fc33b84724f43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1feb7522fecad653acb8a6d91152475486f1fa0f19107df1086c7674074a6870"
    sha256 cellar: :any_skip_relocation, monterey:       "66ee3760def3920ddbeb564ed32f772fe12538c5db6124c7ebd56ef1a82eed97"
    sha256 cellar: :any_skip_relocation, big_sur:        "65289049d189acb12af84edb62fb1fb5b0e8faa55931176aa4430d4442e28cdb"
    sha256 cellar: :any_skip_relocation, catalina:       "a3fec25c1ccaf264a80a81f276aabf54cea670f3e88a48a40c7ffa9c7942bad4"
    sha256 cellar: :any_skip_relocation, mojave:         "eb32f285b1ba6a4ce42e22d4c636aac91f9f899e0a5e6355200f14d7f0ccc990"
    sha256 cellar: :any_skip_relocation, high_sierra:    "74364058c7f8859e71b5b43b80b40c01dd99ce6b80724ef4e97f9a9ea0587775"
    sha256 cellar: :any_skip_relocation, sierra:         "a7019dfc0a37c4cb814f8d116140b9fac999d6d97e6650e0806c02cb633087fb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3ee6afe89723d119075feffe735f4b4d4552d51bab5d79df6b8e100f90d21109"
    sha256 cellar: :any_skip_relocation, yosemite:       "9525132a3c9a1b1ac679102a2a2f39e51dcd1f2ae299a1038701bdf4f945bd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c528a9c75ae75ef5bf9c28db1b40cd8e30fee54029580bbd05c7b5cbc8449936"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install gzip("rolldice.6")
  end

  test do
    assert_match "Roll #1", shell_output("#{bin}/rolldice -s 1x2d6")
  end
end
