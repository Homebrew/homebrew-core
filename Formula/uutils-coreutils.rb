class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.16.tar.gz"
  sha256 "1bdc2838e34b6ca8275cb8e3bac5074ca59158ea077e3195fb91ec0cc6b594f6"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44babb77ea6296065a7bf5171074beea9a79ed9a2a775c89af9eb45ca1e4643b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce3fc84595a5340150970c18189fd7b21e86f48f23542abcf30e5d0e39b7e8e8"
    sha256 cellar: :any_skip_relocation, monterey:       "30727d1ae8136e0185dda1bae30544f0cfdd0298bd5856461aa47f07a652d48d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e94b25d4fd556e42049946a2160d4a1f9ea90e7b163784b0cabb199ddc9a9f22"
    sha256 cellar: :any_skip_relocation, catalina:       "1e5c73a5c33153270c4238f30ab97b28f07b9c1babe76019e85c5f2d1a8dc323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a566f060dbeba0e4f67fd8f68a46bdfe320c691d1fba8d340b611f838d216e"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  conflicts_with "truncate", because: "both install `truncate` binaries"

  def install
    man1.mkpath

    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"

    system "make", "install",
           "PROG_PREFIX=u",
           "PREFIX=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"

    # Symlink all commands into libexec/uubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"uubin").install_symlink bin/"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman"/"man1").install_symlink man1/"u#{cmd}" => cmd
    end

    libexec.install_symlink "uuman" => "man"

    # Symlink non-conflicting binaries
    %w[
      base32 dircolors factor hashsum hostid nproc numfmt pinky ptx realpath
      shred shuf stdbuf tac timeout truncate
    ].each do |cmd|
      bin.install_symlink "u#{cmd}" => cmd
      man1.install_symlink "u#{cmd}.1.gz" => "#{cmd}.1.gz"
    end
  end

  def caveats
    <<~EOS
      Commands also provided by macOS have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^u/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"uhashsum", "--sha1", "-c", "test.sha1"
    system bin/"uln", "-f", "test", "test.sha1"
  end
end
