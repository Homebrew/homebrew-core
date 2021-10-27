class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.8.tar.gz"
  sha256 "11a975110bf75151106b491666b4087a25c9c753f697ee0125fa52c567042bc0"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4cf365ecfff4fe42f9c21a3f9ba64fd2d15a7f14ded65ac8f30d0764f73911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58f80ecda7962fa1818085961891b5218e66ed8fe2f86f38277a3e302c6992be"
    sha256 cellar: :any_skip_relocation, monterey:       "b076abc6627fcff4f6c4135d6848976375c997ec949eaba8b5d19a7615973e4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d1eeffa6a52aa3d932fb0082bccff6456f53b025d77d672035f177c5c6307f"
    sha256 cellar: :any_skip_relocation, catalina:       "d4848d8fa8174ec3c6b12ea3a88739be534f309ace404b050b32273f65a3bb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83aace8e74a5ed355a5bd0a87e255772c130104391924a72851ad3a3fbc60f08"
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
