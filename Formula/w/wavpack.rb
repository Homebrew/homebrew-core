class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.8.1.tar.bz2"
  sha256 "7bd540ed92d2d1bf412213858a9e4f1dfaf6d9a614f189b0622060a432e77bbf"
  license "BSD-3-Clause"

  # The first-party download page also links to `xmms-wavpack` releases, so
  # we have to avoid those versions.
  livecheck do
    url "https://www.wavpack.com/downloads.html"
    regex(%r{href=(?:["']/?|.*?/)wavpack[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b34310b35fa948f6710ffb6ea0da7df8ce665eb993f4fd6a9c674440e8927360"
    sha256 cellar: :any,                 arm64_sequoia: "7a3c71972558779ba65c5333c17b5032577623b5695465cd0fc3fa62b43fe9d4"
    sha256 cellar: :any,                 arm64_sonoma:  "9f2cdfe3f3a442474eb944bcc1ca76878944a16cf89d7c6378f09716ecb7d613"
    sha256 cellar: :any,                 arm64_ventura: "885ff22f136e5db9b1b5fb4ddd578cc8715f958b8e7c02fa177f5b8e3550523a"
    sha256 cellar: :any,                 sonoma:        "db86d639bbac1a81d89399fdaf1f540c2176eaa37843045ca1b342b05cd821ac"
    sha256 cellar: :any,                 ventura:       "1166057de1b8298cf43af6c40e3bf12675179f43a8da756dfce3a04fc1790af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd64ae0ca071579ada44ea6eae97f3ab97f84c6e4f3b2d8c97995937091958f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fbe02a0b9e22e0628253a9ae6bb85a9195108cd2469a0623c66f41fb0464e25"
  end

  head do
    url "https://github.com/dbry/WavPack.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_path_exists testpath/"test.wv"
  end
end
