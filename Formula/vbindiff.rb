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

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2765e76b73db2ad73a57dacd123cebc482dbc90dcded199f38d45fa5b3b63fad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8075454b11304c47a1e77537da4abe37c6188b0cd53c8d74cf920ec9f0015a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ded05d39834aefcfefe2639b2c861410dd94a6a1213ef892f8b5bfd4c1624b9"
    sha256 cellar: :any_skip_relocation, ventura:        "b937359639366c69a2b3227d6c1c5ce6590fcbf30e7a8242e87e37772f42c575"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a1e5857b109bfc7d8f195d34dac26362adba2650385edbc23de485cf4c49f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5988880d2866314fe6fae0eb5ce97c863396553f9575d6d70b0da8b2b66128"
    sha256 cellar: :any_skip_relocation, catalina:       "c7e303922a1f33af5fe107d192a530cfb3d545a55d4b7e681cdb5603e24cdfb6"
    sha256 cellar: :any_skip_relocation, mojave:         "907ff3fce1fcb1cba6e746ea624f84234fe55703caa380b7ee19c1f8bb6cd193"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c5d1025c94e7fe141a9522ed1460bfba8047393d63d59f54b391dec063c05c68"
    sha256 cellar: :any_skip_relocation, sierra:         "d6474b9e6a00c71f2c207c07dbfb015aa428d8f32e193b69c7b4a1f534f128db"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b2f557094c03f5870173b32cdf9e8ff8bd7fd74340adfea7f1db6b6eced367d9"
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
    system "#{bin}/vbindiff", "-L"
  end
end
