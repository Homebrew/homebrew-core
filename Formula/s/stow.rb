class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftp.gnu.org/gnu/stow/stow-2.4.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/stow/stow-2.4.0.tar.gz"
  sha256 "6fed67cf64deab6d3d9151a43e2c06c95cdfca6a88fab7d416f46a648b1d761d"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96b39991344069d3dadb1c7596834de19363bb36e17e32295dd4795b0769f5aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4ee57b369517cb9acd9b55f4ec607d85989439c84c9213584abe7ea11ab5fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4ee57b369517cb9acd9b55f4ec607d85989439c84c9213584abe7ea11ab5fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "9941e9c78e2c61bdb9debae9c950663f1a5f0c1b01ae4baab9669654faf31c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "90deed5604fea78b3d06b106d2a9833b731de947af36c352f49b0c3305dbfb4c"
    sha256 cellar: :any_skip_relocation, monterey:       "90deed5604fea78b3d06b106d2a9833b731de947af36c352f49b0c3305dbfb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc3b7edb838e2a5bac50fc5cb04f9fe33a82ee2c972b6f8cecaa7b17c38a4fda"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system bin/"stow", "-nvS", "test"
  end
end
