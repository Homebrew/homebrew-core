class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta5.tar.gz"
  sha256 "f04da97de993caf8b068dcb57f9de5a4e7e9641dc6c47f79b60b8138259133b8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vbindiff[._-]v?(\d+(?:\.\d+)+(?:.?beta\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e2e6e0b5616b035911aed46c5ab5fe7649886d86dbc880ea42e8c64cb70816c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a3b8297335705d8d6c97b391d707bd8c19d30b84d36e8f045065490230a1298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dba50c94e878fd349ce1d2b73a8029d0441d22a59aac179e717ad32839f4a9af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2765e76b73db2ad73a57dacd123cebc482dbc90dcded199f38d45fa5b3b63fad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8075454b11304c47a1e77537da4abe37c6188b0cd53c8d74cf920ec9f0015a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ded05d39834aefcfefe2639b2c861410dd94a6a1213ef892f8b5bfd4c1624b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ea8ad10cca27cd58a5d1b5e34b2160624eae1d7c36c4e07e31a9c4289c98e84"
    sha256 cellar: :any_skip_relocation, ventura:        "b937359639366c69a2b3227d6c1c5ce6590fcbf30e7a8242e87e37772f42c575"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a1e5857b109bfc7d8f195d34dac26362adba2650385edbc23de485cf4c49f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5988880d2866314fe6fae0eb5ce97c863396553f9575d6d70b0da8b2b66128"
    sha256 cellar: :any_skip_relocation, catalina:       "c7e303922a1f33af5fe107d192a530cfb3d545a55d4b7e681cdb5603e24cdfb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1775e6fbae0723ad70926c4fe72cf62b4627880df9d2c05ae035eec0813ec335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67eb1ec328a7cdfc6a1ffa6f6b8cdf60f106040ef5714d6b1b15067a37f6214"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vbindiff", "-L"
  end
end
