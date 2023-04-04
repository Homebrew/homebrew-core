class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.18.tar.gz"
  sha256 "1eed6317763c2fad1283bac057b25eae81a61fd8f364b814f20e1aaa32d16f8d"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4003f68b8e9d75a87eb125b148d439accaf697f471d7b87f100268edbd5a97da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10e8bffd5bbb29c66d541c21875245aa40c1e48b860e55b5877e07073b117335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc6f89bde9fd736862d4acaedc69aaf967ab64f77f58cc9d4cd128e392813d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "f80eaca3d130d6b5e2ca31420517edac1cce151146f46eeeb68f305ce5c24a81"
    sha256 cellar: :any_skip_relocation, monterey:       "fb565e7b44a2c5e890dab21b92ab8a5130033529027feea26d19c782d555649e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa18544044b9d66f6de5fcf9f2d998c61379cc073229cabe8148968a7d47f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8321923cb46a5d730e9785a44848031d7e62dc1956d9853bece346fda0d2c636"
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
