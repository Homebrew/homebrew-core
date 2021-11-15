class Roll < Formula
  desc "CLI program for rolling a dice sequence"
  homepage "https://matteocorti.github.io/roll/"
  url "https://github.com/matteocorti/roll/releases/download/v2.6.0/roll-2.6.0.tar.gz"
  sha256 "f550e91a4a483a567cfe5ff59fecebce81b01b48e330f80cb7ffe817a4e21460"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ee1a76634bcd487f356b7079a3ae31193a868b95928f10f6506c7950c9643a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a00c98b282573bed8335346fdc2a9dd13ab7eed047583088cd2fb05e48941c"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9900af5f748abd19613f693e082077f422a14956227379adb3740d789e30d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "03f970f61a9ef13cce52f7a73103b524b7e70b1a5ef882a4b6426b47f79d7db5"
    sha256 cellar: :any_skip_relocation, catalina:       "84da55198adbe7417d937de4e85d66f285bc70fea85786e962c9caab4a7511fe"
    sha256 cellar: :any_skip_relocation, mojave:         "e83b58e741695154b169582217226d669c4f2f12cdce20ae7f3b405a31e2dd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bccb762f767b5e4d76cf24e5c4ad833261e2326b174ecc3251de557bf6c9086"
  end

  head do
    url "https://github.com/matteocorti/roll.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./regen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/roll", "1d6"
  end
end
