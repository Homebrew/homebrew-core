class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.2.2.tar.gz"
  sha256 "4a847a3aaf241d11f07fdc04ef36d73c722759675858665bc17e94f56c4fbfb3"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34dd46f1808a92aaadddaff6ba666e9fc8b8f8176457da3c7bb4f96b270eaf89"
    sha256 cellar: :any,                 arm64_sequoia: "ee605d02f32809d10c0a3355d51b58d917e7ca6c10931dca0d01283f5906aab7"
    sha256 cellar: :any,                 arm64_sonoma:  "ac86d76eced038424c5dfb896273e8a8744c2ade7deb8fa2419d27d6c66e2498"
    sha256 cellar: :any,                 arm64_ventura: "59ba3ca1de05093cf91c316bcfc8f8721b89349b9150687de3663494d973dfdf"
    sha256 cellar: :any,                 sonoma:        "483d28e5075b212a65429252bc5b6040e073da40c91114e697a58e903afd4f5a"
    sha256 cellar: :any,                 ventura:       "6917d3d10c1ac7df7235937510bb96bd3430d419b6b5e87372e0c5bbc6f42f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f150d7d9ac4608c05f7a8857022c5189dbfb16a40d6a05515d84000b89c03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d01a9653e50a1be67ffb4823367de0367e32df17afad94e1ec8ee661f06d650"
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
