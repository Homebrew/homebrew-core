class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.20.tar.gz"
  sha256 "127487e8f65e13f9f55a0397e3e9b75ed2d20207a6cee8ef27018bf5309441c4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "693d7413519dfd1512a75ff071c83e9a465541876a214b84c1ec39cdf87065eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa102222a4864b864bf8119b9e0d5d110f55b7a9c9157d7e6576f7f010f7edbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef67b09beca0f75f95c92a6907a8e4fbdae6e2985558d123b6e29fa765cd7d3"
    sha256 cellar: :any_skip_relocation, ventura:        "28f076bbef4a4c6497ea03c36dfee9d3f6483859e70e446816d83cfe93325e26"
    sha256 cellar: :any_skip_relocation, monterey:       "5b8e1fc0846b999260ccf94846ec4c7ba2cd341df413eab4165477221703053a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0da49e2220fdf1857338c4cc4b3fa580fadc5e163b653eb06d3e0fd1ed5a5ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2c2f3826f43bbed5dfa31f86b434fc09bcfbe5022332774a0a0a2b23f9b98b"
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
