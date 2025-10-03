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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "122e356a47499a7c1b8e7d4b4b86fe1f8ff2f32223165464ba2a1c9c68cdf1a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e831e4f90ea7d39b9e846ab0d18048bca802d65a6ecd3b61bfe1e55bbe831345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2632e94c5b807679406f19003c336b49ff755acd982d507ab3c2098e1fe91afb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "419e465f3f605dff8d3eda647491f8d3651ed51a8b14eb5c524b507517c6c422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a049590a86adc0c8c02acf6a869a37a45a47e4e455bf2b2ee2c0bd15128ab43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16c1e072a6f596e4bda1fb3bd99a743cdb1ef6c0ec552f1ea33224f24fb28047"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ebf6bc4b628a0e1908346d0c30198aca1dccfbb2edbaf7e645e60d0a3d508a0"
    sha256 cellar: :any_skip_relocation, ventura:        "2fb5e7883c1aaf26f31da1deba72b7067dbc7e2c55da34b7803f9c33c5b1e327"
    sha256 cellar: :any_skip_relocation, monterey:       "b705bc4228ad82a8eca44fcbe8d0b7d30cb562b32de113de647ee33f30df9470"
    sha256 cellar: :any_skip_relocation, big_sur:        "544443eda6593899f3358c6e7f5bce878ff590f357151b587b3c83785745492e"
    sha256 cellar: :any_skip_relocation, catalina:       "0d08b087dcaf10a5604aba687c8b59c116d4374bb4a9ded7aec3108d3f005b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d1d3a724cf5d7d9246b696aabea665b928fae0d01600cf63710678c207990e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b409c08d9581b3013a05dc62ebe68c3d6bab99b342e8bc1f2911e9a342b18f0"
  end

  uses_from_macos "bzip2"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

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
    refute_path_exists path

    # decompress: data.txt.rz -> data.txt
    system bin/"rzip", "-d", "#{path}.rz"
    assert_equal original_contents, path.read
  end
end
