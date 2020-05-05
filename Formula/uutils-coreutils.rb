class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.1.tar.gz"
  sha256 "67b3fafd21e204cef4ffe04b055e148799523bc021a8ae08a399a9c847ce8e7f"
  head "https://github.com/uutils/coreutils.git"

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  conflicts_with "coreutils", :because => "uutils-coreutils and coreutils install the same binaries"
  conflicts_with "aardvark_shell_utils", :because => "both install `realpath` binaries"
  conflicts_with "truncate", :because => "both install `truncate` binaries"

  def install
    man1.mkpath
    ENV["PATH"]="#{Formula["make"].opt_libexec}/gnubin:#{ENV["PATH"]}"
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
    no_conflict = %w[
      base32 dircolors factor hashsum hostid nproc numfmt pinky ptx realpath
      shred shuf stdbuf tac timeout truncate
    ]
    no_conflict.each do |cmd|
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
