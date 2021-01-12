class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.2.tar.gz"
  sha256 "bfa81e57aede1993582f77965f35b2c9b9018ed1ffc1a04116078141f576649a"
  license "MIT"
  head "https://github.com/uutils/coreutils.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd49ec02727d0c4b48e1b17c0580576d4130256c3dcefa5fe66e5683eda0ad49" => :big_sur
    sha256 "bd2d08c082e4249d9d73dcdc251f8a441d6dad6f949547110ecb96a023c7f84e" => :catalina
    sha256 "421ae0f39ebdea7acf3bfd9f569f376ee9008b4e7bb72340c09628e5b50021d1" => :mojave
    sha256 "b8eb6f2ff0292941b52d1b1ecafad239844b8447a0bce67792b7d4b61b7aece8" => :high_sierra
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
