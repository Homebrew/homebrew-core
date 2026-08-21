class SoundTouch < Formula
  desc "Audio processing library"
  homepage "https://www.surina.net/soundtouch/"
  url "https://codeberg.org/soundtouch/soundtouch/archive/2.4.1.tar.gz"
  sha256 "35d404e6e8c2ebd12fb4000da6fadd75c99e37eed2126a04721828c11c0377ec"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "c7951228bbd5d138811489e81d1e2f40de1332a2ba27787d4a3e1346f0023393"
    sha256 cellar: :any, arm64_sequoia: "d20df6d0628adb9974e1182d76c386a0434705d3707251c1f53341c3d3dea294"
    sha256 cellar: :any, arm64_sonoma:  "c88b7c7ec159c0bb73b577af4f2be1bd93de6eae1910e147ae1b4269f7a0654b"
    sha256 cellar: :any, sonoma:        "9ae6abc9a6bce8dcfff95aab4b5ebf275a8816c9f1c535153fe16d440c7bc643"
    sha256 cellar: :any, arm64_linux:   "4898ccdbf89841539f4c85d68da4a4886f721ed2f52c8bff5b4f9feebd3a5b2e"
    sha256 cellar: :any, x86_64_linux:  "912b3755559a178642af08f10ebd4c540e751b91ed7c7faac9a9eca9cc446b75"
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
