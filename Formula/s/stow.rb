class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftp.gnu.org/gnu/stow/stow-2.4.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/stow/stow-2.4.0.tar.gz"
  sha256 "6fed67cf64deab6d3d9151a43e2c06c95cdfca6a88fab7d416f46a648b1d761d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45497b1333daabd22772491fad60a232d13c06f9f2c4f492aa622ff739ed906a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29df1fe50041ef256b0a88499c935b560755a242690802fdd238d22e936e1c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29df1fe50041ef256b0a88499c935b560755a242690802fdd238d22e936e1c69"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fe39ea684cf123e5719ce2c78b4b2a9224a391fa2e81e14522e973537aaa56b"
    sha256 cellar: :any_skip_relocation, ventura:        "dba69c69de3ca06518f14f45c39affee246a630ecf53c6d6498e58afdbdc5f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "dba69c69de3ca06518f14f45c39affee246a630ecf53c6d6498e58afdbdc5f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c8ec472ea192228536e3bd3826b0156295bebfb6492cdff7b36c50a7c14a7a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system "#{bin}/stow", "-nvS", "test"
  end
end
