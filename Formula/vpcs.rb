class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vpcs/0.8/vpcs-0.8-src.tbz"
  sha256 "dca602d0571ba852c916632c4c0060aa9557dd744059c0f7368860cfa8b3c993"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a039b6f432de6fe7fb3429b6ccad3a822e1249e6b11a3af0d916c98a908b4dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d673e17698f476b16e70b66227623b829779846d0f4b2246cf84c85f8427d8de"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3e52b8fd8ee4aab736d67fc99ed39fc72364fa9a3ffc9db1b8bd0d8b27661f"
    sha256 cellar: :any_skip_relocation, big_sur:        "75d81877dc7c7e8a07b5a1496e1264ac19fd8206f5dcc24de835931a0d1501eb"
    sha256 cellar: :any_skip_relocation, catalina:       "180a02cc1bb06bb9e5f441688d6b1a51e5c531cd6dea68399aba55f3c5691dd9"
    sha256 cellar: :any_skip_relocation, mojave:         "5728bc8e33f81a307c74fe625305c42363a493ff1dc612d604feec971374385d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ac52b231d875679e7bd4da3a09c6b5bc833e5b93fe5a77749dc834b1d82d21d5"
    sha256 cellar: :any_skip_relocation, sierra:         "78c7e415e9bcbdf28cfdda5d37fce9cc7d735b01d61400b41239e0cdee17ada5"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0f1a65e672fd1d2dbc866279835231ec3737e64c514f38a08bf409807e910222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee66bd58892962238c81873d186c5066fd53490328b2c0db6667532565db008"
  end

  def install
    cd "src" do
      if OS.mac?
        system "make", "-f", "Makefile.osx"
      else
        system "make", "-f", "Makefile.linux"
      end
      bin.install "vpcs"
    end
  end

  test do
    system "#{bin}/vpcs", "--version"
  end
end
