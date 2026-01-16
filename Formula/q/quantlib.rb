class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.41/QuantLib-1.41.tar.gz"
  sha256 "c5e9a30fce129660932e643647eb9a14e19ec24344d6b813c57c054187b03bdd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3928aa0f4834d8aabc97762d5fbc4198e5e43ae3e2ec80bde053b094fbc575d2"
    sha256 cellar: :any,                 arm64_sequoia: "232bbfca61db5a8beda3c39c540e25dd4c5115690c4e68bb3f4b6ebc27c01614"
    sha256 cellar: :any,                 arm64_sonoma:  "8243380d2f1efc805c3927a2d67f1e710de7339cf8bb3727b9748db930bbe402"
    sha256 cellar: :any,                 sonoma:        "02f6a2fcfe39e7ab28a6b347ff22c5d80987dbebb87332f9a614f0fbcd47d87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a071b78ff0ecf0971d9460b456beeddf5484af56dcf07a5ce16720497967d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84189c896b25208c88447848bfc8381c33471514d85e316a3e4117bd9662e9d7"
  end

  head do
    url "https://github.com/lballabio/quantlib.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
