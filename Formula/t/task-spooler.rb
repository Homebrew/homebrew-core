class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://viric.name/soft/ts/"
  url "https://viric.name/soft/ts/ts-1.0.3.tar.gz"
  sha256 "fa833311543dc535b60cb7ab83c64ab5ee31128dbaaaa13dde341984e542b428"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "78baa7d9fb718eee974a876fcec66405f2c5ed87f46185fad9387fccf41896ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec87fc500e93595c87fc6624bd6321ce23f58e72c3b6050992e6d0f0856f24b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f452fc17ad06bee57a2b4ea77cc8f8dc353f75de71ff41220675f1d89db96fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "179ccb94441ab71e1ffbf12b2fbe50b8c74d209cd28f338fdd62afc7ebc73b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592a592ddf965521fa01a4733b80524051f29e9edfff2a4d02eb7070d6a674ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc00ccd9f2d7d917d8844ba3a1a83922a308c9c96f606d4ee393994e6c3d5075"
    sha256 cellar: :any_skip_relocation, ventura:        "0c672767f6d5836e3e544ffe55ea1aaec1e16d3d1b5ff5fa0bbeb9c0f41712e4"
    sha256 cellar: :any_skip_relocation, monterey:       "085939ebfcf9dd9d12c920e19961dd80e949fe753a0d5ec436fde0ef3769a4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "601305ac8af305e6660eb7b8326287378d7d0f22ece837f4e8de6359023fda26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e4af081f98757cabedf4d83a4177876f3c363ad5fa89b654b0f43830f0c0be1"
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ts", "-l"
  end
end
