class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.22.tar.gz"
  sha256 "9f15977f15f8fb259d71f941cfa6b4bb7d9cb7d78e6384bcae19b107760d2a31"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1b6aeb013c01852440d3c8b141b1cf27d62a9a0b810924e95d6faa7aa1ad2e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3974bd7cc64dbd00d9c6038fcd02e0139255807073de06813bdf66ea17ad1ff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4304e275c678f591a433360803d6ba87bf2dccadcb21d3def4e37503858df862"
    sha256 cellar: :any_skip_relocation, sonoma:         "69e03aa8e9247d60c3254470a6803ce6c2a95f7a1e17cdaf9eca3a87a7859c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "c70a73d7e4fc89a9ade456eab17d75a639b4b6eefe047dd189fa706edbe2a655"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4c9676c6a80fcf970f434e2bc7fffce751ce15b2b63ecaf3fce2a3a5d3017b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434f9672caa9360ebb124660a3404f808a5ecb62b7f646112433091d9f9238cc"
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
