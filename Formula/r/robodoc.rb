class Robodoc < Formula
  desc "Source code documentation tool"
  homepage "https://rfsber.home.xs4all.nl/Robo/index.html"
  url "https://rfsber.home.xs4all.nl/Robo/archives/robodoc-4.99.44.tar.bz2"
  sha256 "3721c3be9668a1503454618ed807ae0fba5068b15bc0ea63846787d7e9e78c0f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rfsber.home.xs4all.nl/Robo/archives/"
    regex(/href=.*?robodoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "66e865a5ed9bcff4857a56a4e3377c3f7d08150ebd477d3ea585c2607f3f159d"
    sha256 arm64_sequoia:  "20487c94420045784329d4f876f1292f4ddf54e015153bda4999ef5365b0e770"
    sha256 arm64_sonoma:   "becedbbed4480801e9f68683d8b4d360699e4538b435a6f2da766b6142d02a31"
    sha256 arm64_ventura:  "daac2544b28bf80b15e7e55dc680058443e3c34b8c0405e3e8bc14b2bc1da871"
    sha256 arm64_monterey: "2b8577eec80c48eab7323c77dadb33617b8fde3ac834abbd8df2923cd4bc7748"
    sha256 sonoma:         "be14e9b85a7065d98b327d0b20d8515f7dcf05a6a1d6fed73a56443e669cbd8d"
    sha256 ventura:        "0043d16b63613205e223c9fe4128261d01204d961fd50a1b0945d69ccc763014"
    sha256 monterey:       "4b153cb1a62f10633593b400965dc3bec1350c4aeda23c2f0f6174dc8c3ff2da"
    sha256 arm64_linux:    "6108c0143856a92b0385d2d5281e9117d3a8673e32726762dd87434fe2d66500"
    sha256 x86_64_linux:   "960614e0d6ecfe4051cfe544814b4d4008222e2817a0d3146191a5ec7602d570"
  end

  head do
    url "https://github.com/gumpu/ROBODoc.git", branch: "release"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fixes https://github.com/gumpu/ROBODoc/issues/22
  patch do
    url "https://github.com/lutzmad/ROBODoc/commit/0f8b35c42523810415bec70bb2200d2ecb41c82f.patch?full_index=1"
    sha256 "5fa0e63deaf9eb0eb82e53047a684159d572c116b96fcf4aa61777b663eb156d"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    cp_r Dir["#{doc}/Examples/PerlExample/*"], testpath
    system bin/"robodoc"
  end
end
