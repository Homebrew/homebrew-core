class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://github.com/dse/vtclock"
  url "https://github.com/dse/vtclock/archive/refs/tags/v0.99.1.tar.gz"
  sha256 "72ce681381ade2442542f2d133eee39eaa1de7f75c11102e31182402c2fe6e23"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/dse/vtclock.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9bc71b0b4a7fc2c216cb72ddf9111be288923ddbe3ce612fba3b5900714d8edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8251c5182970bebfed0812e9653332dd8f414eb949f5c447a99d43063834301d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1cd6bcab5a2c2dde71190c91cc5758564b741aa04b5947f864d1fba6aed6a743"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c6c0d99a0582e29faf08b44b05d8a9b69193facdb40ade4d98c4d22a798a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5819c67c24bab17b04730f1a9b8571333bd10cd880c9f5fa3d4fd9a41444cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "33c363d3176a4db688176faf1e83d3fe8492fa2efb62361b9c1efef3104aab29"
    sha256 cellar: :any_skip_relocation, ventura:        "192f4a0d954282a6e38a1733c4cfea3c8d50ff06c752cbf1d8ec039240ba3c49"
    sha256 cellar: :any_skip_relocation, monterey:       "f10bddbdc44fb16506a386997ebbfc54641481f84538cb5c0ca7089291e951c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "393f3bbb5eaeb24e1893ea7e71738dc0095d68b28cbbbab6a71cb8ec18aa1492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aaffb5793d37cea515c7e1c1d428225dcd58cb898d088f1113fadb76b9fd0e7"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system bin/"vtclock", "-h"
  end
end
