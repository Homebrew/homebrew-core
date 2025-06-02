class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.1.0.tar.gz"
  sha256 "55c528f2b53c1b30cb704550131a806e84721c87b3707b588a961a6c97f110d8"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efc20adfb97e84ed67eeddd69dfad9600b64d916a30b6ddb37ec1ec86e1b0d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8e49f4ecacb9a3ff50258bc2b33e04eb049b68149bf4bdd362590995ea9dc1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72b467ed6f6f15ec60a3cee34fa365bd1121364afb925999c00304b8a33fde62"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8af817bc30896c6ee0a6d37f0f58345a0c5a9f81ddc1e4f479a9ab79ac5ecdd"
    sha256 cellar: :any_skip_relocation, ventura:       "b695ba77c5d41cff1f0856d9287c72994b8d94d54de414b0447194675c8d37db"
    sha256                               arm64_linux:   "5f63af088aaf76c4349dd441b1423d5df8a6c722247c66d1663b8023d03d8feb"
    sha256                               x86_64_linux:  "a7b684d72256a852a02a9261707c51e1098033aa25bac60b08629d3ae879631a"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  end

  conflicts_with "unp", because: "both install `ucat` binaries"

  # Temporary patch to fix the error; Failed to find 'selinux/selinux.h'
  # Issue ref: https://github.com/uutils/coreutils/issues/7996
  patch :DATA

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

__END__
diff --git a/GNUmakefile b/GNUmakefile
index f46126a82..58bf7fbdd 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -181,8 +181,6 @@ SELINUX_PROGS := \
 
 ifneq ($(OS),Windows_NT)
 	PROGS := $(PROGS) $(UNIX_PROGS)
-# Build the selinux command even if not on the system
-	PROGS := $(PROGS) $(SELINUX_PROGS)
 endif
 
 UTILS ?= $(PROGS)