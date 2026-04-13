class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.net/"
  url "https://github.com/GNS3/vpcs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "73018c923fdb8bbd7d76ddf4877bb7b3babbabed014f409f6b78a2e2b0a33da7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b63b4dc350e0e33be9b151a3fe2a47385d4474fdc109087d8d04110dfd13aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d951f1bdd6279046aa0443e1c950eb60f3c6b144a84a9f20fa8e56f857dc1153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "841d5350b1c1a9086bb1fe1ec5d443dbdfc79676fa98c33f3d070f19eceae858"
    sha256 cellar: :any_skip_relocation, sonoma:        "27946758ffa7ab9b03d92439362bfdaf9b622ca71adf1aa36724afb774cf4da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558242139637e0815cdbfdaed4321ac10c971d349557432f72228f21798d0537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a55d28182cfe00e2761fc39f7014cebf227cf98a019bca9cca6045de5529b2"
  end

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "make", "-C", "src", "-f", "Makefile.#{os}"
    bin.install "src/vpcs"
  end

  test do
    system bin/"vpcs", "--version"
  end
end
