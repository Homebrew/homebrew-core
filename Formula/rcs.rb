class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.0.tar.xz"
  sha256 "3a0d9f958c7ad303e475e8634654974edbe6deb3a454491f3857dc1889bac5c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0daf7ea6b51de2a5e460d0fd097686f5d550449800927fb7a2b34f1abf2171a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c2394da4a1f2a0fc57c82952526c1bf89d8ec977db1c9235e0e1167bad4ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "abe8b396fbf0d241bc072a06cb02f0fb01d63bedc6f7a3cf717aaa82211d0afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "88ee0070ccfd3c5172b97c342c197c00a8643d8ca832477b7f0fe994bb204a56"
    sha256 cellar: :any_skip_relocation, catalina:       "a16720713ee2f30c3f126ca4716b4df5e1e5e68c24d31fd93ea312c2900d2b4f"
    sha256 cellar: :any_skip_relocation, mojave:         "fddb77e2b68d2f0f4f8264d7c44127cb0bd407a275e4123f5096f89be4734fa7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f429e435048ad65275519c990aa4c2c437fd3b5d682865c057fe7f001e93946f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee1b4c1918545b5dfe786e9f3fb11a58d4da85ef4796fdc8fd925c7b7ae2d39"
  end

  uses_from_macos "ed" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
