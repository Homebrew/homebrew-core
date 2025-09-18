class TokyoDystopia < Formula
  desc "Lightweight full-text search system"
  homepage "https://dbmx.net/tokyodystopia/"
  url "https://dbmx.net/tokyodystopia/tokyodystopia-0.9.15.tar.gz"
  sha256 "28b43c592a127d1c9168eac98f680aa49d1137b4c14b8d078389bbad1a81830a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tokyodystopia[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a2f63111d93534d9aee115227c1f069d622d08d0df19e9d9664f653c28b60dc4"
    sha256 cellar: :any,                 arm64_sequoia:  "da35291f169e133bb8dcc321c5114ea62714f6e0eadab7a69cef121e0c76813f"
    sha256 cellar: :any,                 arm64_sonoma:   "16af9fb0facf080bd076d60cd306742fb641f7430cf0c14946e5e37d2d4dcb8c"
    sha256 cellar: :any,                 arm64_ventura:  "b668547ea69b42bff8b084ec960fb1d1b0233179b2b8b2ea5bb83b013ab81f84"
    sha256 cellar: :any,                 arm64_monterey: "6c120e05bb6ced87121536beab4895c0b03d0e94206fe6fafac4a96326bf2e32"
    sha256 cellar: :any,                 arm64_big_sur:  "9e0c8988268eec1f5fe33f5d7f494f636c64690f417e179e37a83f9b4880b315"
    sha256 cellar: :any,                 sonoma:         "b79acb9af00f15c839c1248e5cd38897f8d8dff2fe20cd87033bdc93573458a5"
    sha256 cellar: :any,                 ventura:        "21e551f8a8e43d5c841619fa462b209aa25a18140cbe0ece3f923a14e3cab1fa"
    sha256 cellar: :any,                 monterey:       "60710bf05465d1a0d1b9820998971cbe2ba9387e4bb121bc6aeadc4aa00a2d91"
    sha256 cellar: :any,                 big_sur:        "f771602cfd9301739750f839295241f829528eee8ecfe02ac95b55fc24c3841e"
    sha256 cellar: :any,                 catalina:       "eb04133c9d459ee1ab9a4fe00b3f6b31621d9df2672a252784779a44a5991b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6c1c01fa3151f25a7d15fde5db6d0c5e27cf836b8b57d40c4f39bb3a82dddec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1babf4df457924711f3ad2fc7e8f9f797950f53de9f1b740290ec1c112ca83e8"
  end

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tsv").write <<~TSV
      1\tUnited States
      55\tBrazil
      81\tJapan
    TSV

    system bin/"dystmgr", "importtsv", "casket", "test.tsv"
    system bin/"dystmgr", "put", "casket", "83", "China"
    system bin/"dystmgr", "list", "-pv", "casket"
  end
end
