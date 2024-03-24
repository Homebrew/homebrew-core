class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.25.tar.gz"
  sha256 "e6e4626e18eb5bd68480fc4860dc6203259a931d0357f8da900d8f5d6926c7ce"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c24e31089b0d72409df86ecfe632ce01bda462f8fa97ac6fee5c60f0c52e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3eccbd95ffb887cca776bb9084507f61a7ef5306ee715ad7ff43c88ff4bc87be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc98a61c7ee5d1e73b3a2a995f7151650a3f7b6c4d7bb40c38fb7328f1735cf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "16cc6e5bbcfd7e39bcd20af9aa5a97afbaa24802c423e03c5049165868439c12"
    sha256 cellar: :any_skip_relocation, ventura:        "f96b555307a32b0867aca5360e3e36c91e562584d17698e10096b0c5aed04865"
    sha256 cellar: :any_skip_relocation, monterey:       "9007f6c4d9273868e4dd3e552a9c008a2c0728f0d838e0aebe271486f03c0798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13270ab8ead9790f2685720a039a94aedb78c399151fb1e9507764bc28ca8974"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  end

  def install
    man1.mkpath

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install",
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
