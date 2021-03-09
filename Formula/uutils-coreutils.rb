class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.4.tar.gz"
  sha256 "784c93adc5915c5799a66504f0163e9b2facb9fee91094e72603097868527289"
  license "MIT"
  head "https://github.com/uutils/coreutils.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f2252a6c250d1343b8b2813642da34a3a3352b9eeb03eed8fb2b57341ab76a23"
    sha256 cellar: :any_skip_relocation, catalina: "77619897016e6b7fa974017c32a4579fa723900fd8e3964f0e8ecce824b45817"
    sha256 cellar: :any_skip_relocation, mojave:   "0f5da4151a88f11e2e2cb3991fb0d3fd456eb55637c17a833fd346fe480434fd"
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
