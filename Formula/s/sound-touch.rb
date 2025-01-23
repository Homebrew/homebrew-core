class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.3.3.tar.gz"
  sha256 "43b23dfac2f64a3aff55d64be096ffc7b73842c3f5665caff44975633a975a99"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "13611f86407c3a9c7f4504580c7827389c56000fda7a9fadd930ce7e88be445d"
    sha256 cellar: :any,                 arm64_sonoma:   "1fe2f2065c864e1da3bac986c5222e9a55b131fadc53275de39f5361c6fd00fe"
    sha256 cellar: :any,                 arm64_ventura:  "8165de105d4da09709ace4e9bbe43767e9f7151f4cb69455cac3ccd6379cf480"
    sha256 cellar: :any,                 arm64_monterey: "5736ffb517df2c516cc9d46120888664e3707a797618e20e614bdff935866cc6"
    sha256 cellar: :any,                 sonoma:         "8c25300640bb261c7b370b5f285d3f296f57c76a71bc04bc4d055f0eae982124"
    sha256 cellar: :any,                 ventura:        "7c5bdb94f9c5321743ac2db0f520ba0c8c97389729ae96ffbf428cd4fc1f69ad"
    sha256 cellar: :any,                 monterey:       "c2f6ca0d546e6c96f0eb39cda31822667930c26f06df1eac5ad03119a188ed1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3162dd6ee8f3c0f99ec51c370328e92c4920b3ed4f1d4502d4c79d7733593ed8"
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
