class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.16.tar.gz"
  sha256 "1bdc2838e34b6ca8275cb8e3bac5074ca59158ea077e3195fb91ec0cc6b594f6"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bb8efbf99a978cf3fb35446fde1a6f16668c5a6ef613ca80fec8940184b7a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86d96212c06714de24acee35746cb09c2a1e345d8acc54e05f6b393d14062a37"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0ac42b5708c26d1e9e58a3a173452bfae8b76a142910a2965e7acc5838c6ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "38022b2cd2fbd005fcb8bbe94968e73d2b3ac3defe3de41bb4c8402e79ed8861"
    sha256 cellar: :any_skip_relocation, catalina:       "21a588651b729fe838551f42127efa6e2ba1079a651ea44d313cc5e4fd96a63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe31d269b27279bf63ae01dca1670a955bde64873c1b1311f45cc1a9bbe3336"
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
