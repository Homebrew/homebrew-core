class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.26.tar.gz"
  sha256 "2a0e8511f1e6adf7f1003ce4536b8a8bb1b2289364efe55edf96f2fc9e2f00a4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a888d2935b2c1e834a16a671e9c9d9095afa69bc16d462d48adad0580b70813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3b7b267465a1c92bdf51eee22263af78df24e8b0dda8acc42b27a5cc092fe80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7695cc8a17ead073eddc4294eda80c30c1c1221c33122d17f162459d9750b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0df1c93b17982d1c1719ef323eb58894ff575722b0918d1284eaad6ea3332e39"
    sha256 cellar: :any_skip_relocation, ventura:        "c1303b92e6abc485692f4eff534ab51542517ccb164aef291408f891e088886c"
    sha256 cellar: :any_skip_relocation, monterey:       "03ef48c72913a452a39f8426945e6ba7630fa3254b52795c09a9c329246fce1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9478b683ba3f6953ef39320320f6755c6693e78b412e33e80ee630401effb9f"
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
