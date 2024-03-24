class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.25.tar.gz"
  sha256 "e6e4626e18eb5bd68480fc4860dc6203259a931d0357f8da900d8f5d6926c7ce"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2168112f262abd285613c64ea470b2f1d84e4cc6549fb574dc726ac0ea43fdee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74900a9e061d1e5940ef97f5fdf7de26c39ca3ba6cc078519ad71a55059c0901"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf206b3d77eaf5d8142921b99458ed22be8d87473a7ff9e36f8413756db86b3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6f1d1a27a1edeb91e674d65f5ed8367fa8ce3a6bcb77df36a61b0a17b4585d5"
    sha256 cellar: :any_skip_relocation, ventura:        "dfd32cabc53debbd0ca594164eb20082f0d2dd93d35ab274c05c52d37e5ff4fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e6593f361742e0be67d71cebb0a5f1eb133ebb887df44d0b94d817913672375c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039eab8b279a0325fb5bba1d6df056e8d56582b9b66898425db5e0f71509f5de"
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
