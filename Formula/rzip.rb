class Rzip < Formula
  desc "File compression tool (like gzip or bzip2)"
  homepage "https://rzip.samba.org/"
  url "https://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz"
  sha256 "4bb96f4d58ccf16749ed3f836957ce97dbcff3e3ee5fd50266229a48f89815b7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://rzip.samba.org/ftp/rzip/"
    regex(/href=.*?rzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a049590a86adc0c8c02acf6a869a37a45a47e4e455bf2b2ee2c0bd15128ab43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16c1e072a6f596e4bda1fb3bd99a743cdb1ef6c0ec552f1ea33224f24fb28047"
    sha256 cellar: :any_skip_relocation, monterey:       "b705bc4228ad82a8eca44fcbe8d0b7d30cb562b32de113de647ee33f30df9470"
    sha256 cellar: :any_skip_relocation, big_sur:        "544443eda6593899f3358c6e7f5bce878ff590f357151b587b3c83785745492e"
    sha256 cellar: :any_skip_relocation, catalina:       "0d08b087dcaf10a5604aba687c8b59c116d4374bb4a9ded7aec3108d3f005b1b"
    sha256 cellar: :any_skip_relocation, mojave:         "aa81be3378f5e5410013d08bddf9c4f9c605d639b7a1e53f37bc7cf7264aae82"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fec6b24d1b5d0555a7cdd732846cfc6357d4fca1b3ff59a3c5fa27e3bc2f4d9e"
    sha256 cellar: :any_skip_relocation, sierra:         "89a5e7ab518070df7c3f5091a18a412b72910b58a191222e915b1ed9db6ba570"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4eedb0ca975a72a4591d1e386d1ae01a546fb8401ea4f0b05c0fa71809e159db"
    sha256 cellar: :any_skip_relocation, yosemite:       "170150a7704b270df0a1cce7f1cfde689e245f9a9f628b5f0415df5ceae89e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b409c08d9581b3013a05dc62ebe68c3d6bab99b342e8bc1f2911e9a342b18f0"
  end

  uses_from_macos "bzip2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install", "INSTALL_MAN=#{man}"

    bin.install_symlink "rzip" => "runzip"
    man1.install_symlink "rzip.1" => "runzip.1"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.rz
    system bin/"rzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.rz -> data.txt
    system bin/"rzip", "-d", "#{path}.rz"
    assert_equal original_contents, path.read
  end
end
