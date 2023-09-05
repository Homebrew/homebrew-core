class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.21.tar.gz"
  sha256 "a3295f7ec0600f379ec829649fcedc0432f493cbfc64ad10a1f9b6c52e874387"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "633c978ebdb7428d88f33be724f27525c74e1f7d67893cb09fa800ef708f955e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c18476b5dedad04b81a7049047142979575fd4925dda0d948ac41b7dcba2641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2681dbdf40f52b5652a1b0b4c2fe55429f559fb5bfe2c1e0caad569d9f907e60"
    sha256 cellar: :any_skip_relocation, ventura:        "c9aa801571acd0d4ec42c64ec4fcbb70da364198d26dfe28e432599930286afb"
    sha256 cellar: :any_skip_relocation, monterey:       "52bf1b2ec54d8b625a1267d61f9d653b3e8a0403abb58a15893a2fee7489917b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe83393a51cfaf98091be0e5a93ab1feaa6dd6e992bc02b38b1c8b4a2b56f0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80546c14721258c8e751fa1298042449450df2e9411a5bdec22d7768d94eaacb"
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
