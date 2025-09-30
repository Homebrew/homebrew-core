class SigrokCli < Formula
  desc "Sigrok command-line interface to use logic analyzers and more"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.2.tar.gz"
  sha256 "71d0443f36897bf565732dec206830dbea0f2789b6601cf10536b286d1140ab8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?sigrok-cli[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "702bb4ee199576914bbcb83e20cfe4e4e960877ec8a9e1bc112910abc180efbb"
    sha256 cellar: :any,                 arm64_sequoia:  "fd787456a3085648cbf83f56294acc9c37579a5dba2338d8d56c74710c03ee90"
    sha256 cellar: :any,                 arm64_sonoma:   "a5e82221775d890da9132fdc4326606838e1622c0e692248e2e2efd54839893e"
    sha256 cellar: :any,                 arm64_ventura:  "c829705552edd7e001c393e73954a4f95a3b50319994943897c05858e3734998"
    sha256 cellar: :any,                 arm64_monterey: "f097768e26c50de6aafacfb8e1e1db78837620683d42dd1cca848c0797794bd0"
    sha256 cellar: :any,                 arm64_big_sur:  "176086043c5408747b737bf7f8984b966cc23f409977ebd4d01b4f127d7fb580"
    sha256 cellar: :any,                 sonoma:         "e0ab196bf123ced48ba23364127c709e7cd3dde29842600e29983b9ecc5a7d14"
    sha256 cellar: :any,                 ventura:        "57ec56b4589b3801668bb98fd0c83298ec5958e111bec41a5294f48257db7769"
    sha256 cellar: :any,                 monterey:       "c66c8195acaf4a1865d2df389b0295f9ccf6cca5f4cf6db78b3ad686c35bc3fd"
    sha256 cellar: :any,                 big_sur:        "5a02c04e5b3148c70995ca652850eb8146ab436d102c19f5c96b39a578c5b31e"
    sha256 cellar: :any,                 catalina:       "79af0118b674614921744d9f9a29c929e95ec0a5b60613ddbd31fa27f3fa18af"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ba72045f4b14e589786904ff79dd12e08890d0379ede83f2454f75333d314e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b58556d1098376a5d2f261f7e437a18bfa72b6cf8ba63deec1595422ee63c4f"
  end

  head do
    url "git://sigrok.org/sigrok-cli", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libsigrok"
  depends_on "libsigrokdecode"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./autogen.sh" if build.head?
    mkdir "build" do
      system "../configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    # Make sure that we can capture samples from the demo device
    system bin/"sigrok-cli", "-d", "demo", "--samples", "1"
  end
end
