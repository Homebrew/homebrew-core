class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.0.30.tar.gz"
  sha256 "732c0ac646be7cc59a51cdfdb2d0ff1a4d2501c28f900a2d447c77729fdfca22"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2411a79699ee2d457d9900f8f59c1ab0fa747dee24dfcf4f7d105aedce69fe66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3964a0c2549b404f6ec0439cf948b8505cf9e2839ee4ed64e881570a247ff3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5455d414d3adc4fb4dc54571fe451487adab71d71ace76e6476c1f8f235a3210"
    sha256 cellar: :any_skip_relocation, sonoma:        "367bf4cac0c0c9042eef29604d1a19178b1a8ecddcb2d8a2f58069f06da99f03"
    sha256 cellar: :any_skip_relocation, ventura:       "0db44149c4963e57a301d574a0027c76b0668a935ed7a93003ee0c06b8212d67"
    sha256                               arm64_linux:   "ceeb9ca9c70ab137505a4c6dc8e0ab69b5360cb76f4fba859d993de2298b46d1"
    sha256                               x86_64_linux:  "e18edcc1973ef26762cbeefe8d494b01190d886fe8e31ae0cb5fd2b6adcee0a0"
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
