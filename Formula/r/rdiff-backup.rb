class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/29/57/2722bf1fd732fed762f3307454df1175314f547ab0f069e2d4bc831d8d40/rdiff-backup-2.2.5.tar.gz"
  sha256 "86e2826b784ec3ea4ef187d936ee5f15277422c4077efa0156ef67e3139ea08e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2d2877894989ffa17a12b7ff85dc033ed4674f80ff0985868fc24c5147ceabe8"
    sha256 cellar: :any,                 arm64_monterey: "c0d1d60d0e87b916d2e6d68c1098d3c1cf2adba542d231ffb3b482370f58ef35"
    sha256 cellar: :any,                 arm64_big_sur:  "b46a63968555ef77bf46d611b38b8e1812374dadaae58f5fc87effcd3ccfa0e8"
    sha256 cellar: :any,                 ventura:        "2bb7ed15b8918441f8a7a8f3ff818bacef4a187db469acf9b4f4c8080278a9a8"
    sha256 cellar: :any,                 monterey:       "83509a3b88f86bd949f58fd8bcbb87cc1249ba7ba87f4b818debbd3471ce5fd2"
    sha256 cellar: :any,                 big_sur:        "7d0f2d26e70a4048246f7c083783783eeb2a7be1605fa8784265ef21deca8e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70686f1def5208b45dc7f0b896ae5619b0db76be125a82ad9b2443ab14eeef04"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
