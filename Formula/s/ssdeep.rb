class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "https://ssdeep-project.github.io/ssdeep/"
  url "https://github.com/ssdeep-project/ssdeep/releases/download/release-2.14.1/ssdeep-2.14.1.tar.gz"
  sha256 "ff2eabc78106f009b4fb2def2d76fb0ca9e12acf624cbbfad9b3eb390d931313"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "e9bde3f8a96c900db97df6ad5bbfdc7c3b846229b78882cb6413fd58f0dc00e9"
    sha256 cellar: :any,                 arm64_sequoia:  "e15c23668877e2528d0ef6a446904c5c9802095b19bcbaf037ce382376c50fb2"
    sha256 cellar: :any,                 arm64_sonoma:   "b3e4cc557c4481853959fe15a61314d395df95e655e6809c89dae20db8eb8429"
    sha256 cellar: :any,                 arm64_ventura:  "4c852376c9936badb32f51835c1c71622b5ef3c6c9ca9206ae43dd99a23e7d73"
    sha256 cellar: :any,                 arm64_monterey: "90d04d23cbaa964e22b512fc048d6b7c07c268ea1560ec8e9a9e62f7e8f32182"
    sha256 cellar: :any,                 sonoma:         "0b284332d1db2589577a0714f875ff8149146ada15d3cb443190977024145e46"
    sha256 cellar: :any,                 ventura:        "1fd2896aaeb79fde178e73b814ff02d91f92f0c6a80331adf4c7970c7fce40ac"
    sha256 cellar: :any,                 monterey:       "2addd0f558292956dd191891a0187dffdb979e8cbe387280fd2920dc1429be06"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0efcfc1a319de30ee921f93ee4296d34d801a59381b47169accce5630181b93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d62ce2005fd901e4a363b3f6592dee0388e9114d323a058499d16e8dba9c4d38"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      ssdeep,1.1--blocksize:hash:hash,filename
      192:1xJsxlk/aMhud9Eqfpm0sfQ+CfQoDfpw3RtU:1xJsPMIdOqBCYLYYB7,"#{include}/fuzzy.h"
    EOS
    assert_equal expected, shell_output("#{bin}/ssdeep #{include}/fuzzy.h")
  end
end
