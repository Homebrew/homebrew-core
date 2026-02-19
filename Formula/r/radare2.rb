class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.1.0.tar.gz"
  sha256 "52847eefc0fa9713b8c36e9afe45e0eee0e2d140e4f284c1ad43ae442f76a0a9"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "240320fa43cb3033394631e6f6f5f33dbe1c1b4d693f119f557a9d0c0ac6da7c"
    sha256 arm64_sequoia: "94bbe295d04ba3495b1f944f351d0d075bd94c1fc9c4f799af847e69611f5918"
    sha256 arm64_sonoma:  "484a27485a038749efcf7fa36785bcaefc6587aaa3efe11b1b5ccd8f18f32cdf"
    sha256 sonoma:        "12125ce71b89e52f82f9136d0e03116cbd35934c8e2fbd23c8b0eea1afdcdd8d"
    sha256 arm64_linux:   "b2965a379545e0946594687eeeff334355bcb3db3ff25815b2d6e4daa6cb43cd"
    sha256 x86_64_linux:  "ce8996bbdb615680c988fd10d44fea3f0f70aae717c78629beedfc9ad9917075"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
