class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://github.com/uutils/coreutils/archive/0.0.19.tar.gz"
  sha256 "c21564fbbe0d4742290f98badaebfec54177c42dbfe755c30997a088d9897060"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe6fd0d663fb0f96d211a2fdd2a8c4ed2e3198e70004e10757d347206d8970c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1008605d10b3941f62ad431c0fc0f964417f02246c8413b92688b2b8a01b7d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1d0cdaf961b46e226bbec997c10ce0d6381598992ad1ac728f70964a5e23e0"
    sha256 cellar: :any_skip_relocation, ventura:        "42e645f78246eb81929ca8a50c3afe32042edfc8f22665cbcefecf3e0ce9fccc"
    sha256 cellar: :any_skip_relocation, monterey:       "3fcb517b80adc3343fd0eb24216932aa6cb786dd2752f2926ba35a183d143c66"
    sha256 cellar: :any_skip_relocation, big_sur:        "77f266b576808d9c88b77bf588d5a706edb376f28b2ec69b1f779f5e6eedfeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d4d1edd7449e5219d18284e755158b99d860ac14b4c840b1ed5b6add7dbac7"
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
