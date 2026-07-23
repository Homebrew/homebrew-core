class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.15/recode-3.7.15.tar.gz"
  sha256 "f590407fc51badb351973fc1333ee33111f05ec83a8f954fd8cf0c5e30439806"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "405e897606d94d94722132d288750bf0c609f9a545b88dbeee6a80882dfec1cb"
    sha256 cellar: :any,                 arm64_sequoia: "ae73bc0697143ac801aa1e31b27be127877d06fa6a366d8fb899a3261bb8de5e"
    sha256 cellar: :any,                 arm64_sonoma:  "8f613a6ea840f5097d52b38a046db4d0fda412b906a98e215375104e9fdbeb05"
    sha256 cellar: :any,                 arm64_ventura: "18e154be855e36d7352b192f4a886cb461bd9580496b90100b2c3d8eb2b14297"
    sha256 cellar: :any,                 sonoma:        "99fce903fbcf4b521eef4e7f9017f4cd11b772b5ae6eda8b85841a83b4d47436"
    sha256 cellar: :any,                 ventura:       "ee4a5b927e4e1de464895aadc1a9b6d51bad94ac2617ef91fc49678fee7f6685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae507a89cd038723bbc75c818979f9519917eb3ad718ed0debb023130eedc571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0863f449422de1753db9eec031492961cbbdb64e76b75211ed354b320cb96a0b"
  end

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
