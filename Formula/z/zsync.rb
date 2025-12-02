class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.6.3.tar.bz2"
  sha256 "293b6191821641d3ed6248206f8f9df0bf46e6ee2cf8b4dd97cfd1d5909edb9a"
  license all_of: [
    "Artistic-2.0",
    "Zlib", # zlib/
    :public_domain, # librcksum/md4.c, libzsync/sha1.c, zlib/inflate.c
  ]

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d4a20e196767857208a02278c4b0d5bf3378ae40402d1a67e948bf58cff27d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39991c4aa022ce2fe1b3d62b30e2c7e130be4e4e98bf6dca844f28ec8afdfe8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "800299bfc82b2ce9970159a2d0efcbe445c74024a357aa4a3c2f8a74c4ed871b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8fcb43f6827e4c2339a9ec5f365c05372c9d17ca91e9fef076f84b784efcd65"
    sha256 cellar: :any_skip_relocation, sonoma:        "db75f0fa2e8fd02c11b06fb4a75ac536da7aa768f35df369137bf72d87490c36"
    sha256 cellar: :any_skip_relocation, ventura:       "54804831f99313425941c41263b6b9e875db47ca171dee2a24d370e335e8fcfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1d6196e007d24f8416604d28391ed198a28f30fe72b98fc8d3623b4952b01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c5c7c1ea629dd5b29e60e554bd87b30528abe65e58730a8034c680c4eeb476"
  end

  head do
    url "https://github.com/cph6/zsync.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    if head?
      cd "c"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_match "SHA-1: #{sha1}", (testpath/"foo.zsync").read
  end
end
