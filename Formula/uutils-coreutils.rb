class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.17.tar.gz"
  sha256 "a133449db283c145483e7945c925104007294d600b75991c5dad2cc91dc11d2e"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528c706f0d8cc376fc787b0ed667c945d9ae61f58f5681449389b8759700f013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "badf3241383299397d8965cd1b1459f09726c4b7ea6ed2f15d649cc51a904812"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e413c572c17bbd767903a81310857aaa9795560445f30fdbd516c0574505ce91"
    sha256 cellar: :any_skip_relocation, ventura:        "5dadea5d9ecdb0f04179ff54f16c2da4db18f5dc9e4437f8dbb6513e0e3a013b"
    sha256 cellar: :any_skip_relocation, monterey:       "a426e0df8dc9729fbc0a7490fa4df17c215cdb03e42fb01cb8d49b68548506f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eb26cc251ad81ff38c416a74ba21dc5e2678cd52b5a91ea7fe5d8c628709086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8313b5ae4f2c06c9fdadad410a469b478a17ce0b26926f8373e048ed522d547a"
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
