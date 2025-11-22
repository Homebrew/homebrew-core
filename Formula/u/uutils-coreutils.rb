class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.4.0.tar.gz"
  sha256 "5f0c3f97b807e72edccc844c6a685ec9862199f16a665df07de5b1d20ec21233"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a267c305c63cfb23b41da28f42b7d61974f1a9e4e4a0193e280e02e3a2dc2c0"
    sha256 cellar: :any,                 arm64_sequoia: "2a59ef6947a0b8a672103ff080af286aaa00fe952e96449ad5ad7150c1296b99"
    sha256 cellar: :any,                 arm64_sonoma:  "e931c2a51f4dbf5e7ec88be22de457f6a8df37c6fece636f9e7b118e1302f46d"
    sha256 cellar: :any,                 sonoma:        "c96c4aa0a2fd1d4d8cd1350529a2fff794ce70a88d2a40b55aeb3faf9f502eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8de9bf8b860974105a72e75e944a7e7ff854066452c4dfdb0f43f19697c9dc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca67406d62cfa778de25f0d0dc282849aa0ec8a5c2e76c87392f5102284ef391"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  end

  conflicts_with "unp", because: "both install `ucat` binaries"

  def install
    man1.mkpath

    # Prevent to add a feature for `selinux`
    inreplace "GNUmakefile", "$(SELINUX_PROGS)", ""

    args = %W[
      PROG_PREFIX=u
      PREFIX=#{prefix}
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
    ]
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", *args

    # Symlink all commands into libexec/uubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"uubin").install_symlink bin/"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman/man1").install_symlink man1/"u#{cmd}" => cmd
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
