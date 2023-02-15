class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.17.tar.gz"
  sha256 "a133449db283c145483e7945c925104007294d600b75991c5dad2cc91dc11d2e"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2564c384fc6f14705bb7fee5945456a367f1d57c8c9bcdf389dd6a6568d56b9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655ef4922e443b52ec8f6736ca33d083e71a8d74230817e2fd900a3002a09002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c838e956287ce194ea90ab583ad523061eb4ae7844dc17b71c57df746b69fcdf"
    sha256 cellar: :any_skip_relocation, ventura:        "ab18409fbea0b22b8538a60596dbf6bd5290fd7c1099f4aa5f86b6dc1ec169c6"
    sha256 cellar: :any_skip_relocation, monterey:       "1da67fbe06daa0c1346ee089d2eedb533033753a757afa5dd0c3d554baa81f7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da380a5b907247066d2d2283eefe0753831e2394f65f7b2d1bfde35a7f5fccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66439946cfaf19010f6aecfbf98dea36639d4377ff012191456b9afd2aa14f1"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
    conflicts_with "truncate", because: "both install `truncate` binaries"
  end

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
    no_conflict = if OS.mac?
      %w[
        base32 dircolors factor hashsum hostid nproc numfmt pinky ptx realpath
        shred shuf stdbuf tac timeout truncate
      ]
    else
      %w[hashsum]
    end
    no_conflict.each do |cmd|
      bin.install_symlink "u#{cmd}" => cmd
      man1.install_symlink "u#{cmd}.1.gz" => "#{cmd}.1.gz"
    end
  end

  def caveats
    provided_by = "coreutils"
    on_macos do
      provided_by = "macOS"
    end
    <<~EOS
      Commands also provided by #{provided_by} have been installed with the prefix "u".
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
