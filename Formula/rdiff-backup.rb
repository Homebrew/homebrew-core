class RdiffBackup < Formula
  desc "Backs up one directory to another--also works over networks"
  homepage "https://www.nongnu.org/rdiff-backup/"
  url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
  sha256 "0d91a85b40949116fa8aaf15da165c34a2d15449b3cbe01c8026391310ac95db"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "76ac2c10776a2dcb230f07b95704c65522cae20865a9bf4e4772c86b94673bda" => :mojave
    sha256 "899687c88770af610d76f66f02da736a2a62ac4676f0f80796dbbae1d92bc47f" => :high_sierra
    sha256 "7dcf4c878ccafc113e5742c83214f946dd3a55b472e086a944e918bcee1cf2bd" => :sierra
    sha256 "f06f79bc1536dbaa990e6005565f18de05e9dc12deb09701a504ab6bfc8b8f11" => :el_capitan
    sha256 "35f6a0f726a680d639f7a1c83af8e27d046d5a68a334bf19d47eaa363748767c" => :yosemite
    sha256 "5b0eab2335afe2d298cd51737c744d052536cb0bdbee780819496e1000a3b179" => :mavericks
  end

  depends_on "librsync"

  # librsync 1.x support
  patch do
    url "https://git.archlinux.org/svntogit/community.git/plain/trunk/rdiff-backup-1.2.8-librsync-1.0.0.patch?h=packages/rdiff-backup"
    mirror "https://src.fedoraproject.org/cgit/rpms/rdiff-backup.git/plain/rdiff-backup-1.2.8-librsync-1.0.0.patch"
    sha256 "a00d993d5ffea32d58a73078fa20c90c1c1c6daa0587690cec0e3da43877bf12"
  end

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    archs.delete :x86_64 if Hardware::CPU.is_32_bit?
    ENV["ARCHFLAGS"] = archs.as_arch_flags
    system "python", "setup.py", "--librsync-dir=#{prefix}", "build"
    libexec.install Dir["build/lib.macosx*/rdiff_backup"]
    libexec.install Dir["build/scripts-*/*"]
    man1.install Dir["*.1"]
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
