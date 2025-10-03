class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.4.0.tar.gz"
  sha256 "3dda3c9ab1e287f15028c010a66ab7145fa855dfa62763538f341e70b4d10abd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "023d3c93b87887210efbaea61e5fb4f8d1ad156ac99f69675605df0a053d1d62"
    sha256 cellar: :any,                 arm64_sequoia: "73661d9ef5c0d165ac98a00a189973b287b38609523d2807ca89edffcfafaa73"
    sha256 cellar: :any,                 arm64_sonoma:  "b262bd9eaeee94084f75336d6e9d3e3beaa631dd8168a004ced337f36e433828"
    sha256 cellar: :any,                 arm64_ventura: "c0e31eee1801826eb30ca5a753f35c11ec679b19b802554d00cfb096b494af0f"
    sha256 cellar: :any,                 sonoma:        "15882d0b1444f3373fbe8440de6fa9b9d561de20a1c2cfad22c40894c3c182d4"
    sha256 cellar: :any,                 ventura:       "f7b88e434c4ee3c9ac2e9d5676f205fa40da9ddb7d32e89ad2e618aac70b6556"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "351f5272b57863806eae41298ba7658c74fc3974de8b8baf8677203701535b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ded546915e0db8508a66b0883f0385e89a5b5ae88f5c4607d27545c3a5c1697"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append "CXXFLAGS", "-std=c++14"

    system "/bin/sh", "bootstrap"
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "SoundStretch v#{version} -", shell_output("#{bin}/soundstretch 2>&1", 255)
  end
end
