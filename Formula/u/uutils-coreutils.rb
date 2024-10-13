class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.27.tar.gz"
  sha256 "3076543a373c8e727018bd547cc74133f4a6538849e4990388f2bbea9a9aff6b"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6e7b4849bad915292ca0915d2f014be85866240aa4d2be2fa1022b0a03cf6751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe7f3acfd38d03324688992a9d772ee73b20ce6fb4c0f822b19b8644edee717d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a5d5a1a16401ff96a7aecc0c71fb2c1612e350de3c9ca98eac368bf3060ee9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e37c96f80334ce66be4aa8fbd1c7bb9537a7c0693bbd7b7a8731c8ae1293ca1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "79b54832494706587f5b9545690ee91e857d4d4ac86da00dfa35ae200997ca49"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d1e609f322dfd1cd054640308216fbebd310e20ab8c10039ea136386ba3775"
    sha256 cellar: :any_skip_relocation, monterey:       "fde4e6ddbb70db21ae8bd91446cd7e6e278dd78645e7a9a5119b417fd7ce5d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba63b4c38b3041f81d0340345f6929e395d490f67816851a148f413f586a42a"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  end

  conflicts_with "unp", because: "both install `ucat` binaries"

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

    (libexec/"uubin").install_symlink "../uuman" => "man"

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
