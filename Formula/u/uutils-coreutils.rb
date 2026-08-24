class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.10.0.tar.gz"
  sha256 "f8e68cd0e3629378f047544ead272161a83211c43f4985a9f52944e5db8f1a44"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b179023f2b0571717c60305f800671c21f4e74fa6137d7a367bb1f389ae240a0"
    sha256 cellar: :any, arm64_sequoia: "d97b9f9b9c47dd9c00f517b6e84395af965b76aadd55c432526ae4edb5296e7a"
    sha256 cellar: :any, arm64_sonoma:  "8ba7bf5c12fd0dfc809639c249a563a4c1bf2f962afa145f24bfe68b3bbc65ae"
    sha256 cellar: :any, sonoma:        "6796fb9dfa6fa236205f5968aaf75c4e98c122a2a0d7f53b1b915df34e406604"
    sha256 cellar: :any, arm64_linux:   "7cb12e953326cd6ce08e74f6773f739c307f8727aa22c447f171018c2a93f83a"
    sha256 cellar: :any, x86_64_linux:  "01d7e7b84828e70a70b39cd9387c516df5163fb5729565182f44c446d6b128fc"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    args = [
      "PROG_PREFIX=uu-",
      "PREFIX=#{prefix}",
      "SPHINXBUILD=#{formula_opt_bin("sphinx-doc")}/sphinx-build",
      "MULTICALL=y",
      "LN=ln -sf",
    ]
    system "make", "install", *args

    # Symlink all commands into libexec/uubin without the 'uu-' prefix
    coreutils_filenames(bin).each do |cmd|
      uu_cmd = bin/"uu-#{cmd}"
      (libexec/"uubin").install_symlink uu_cmd.realpath => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'uu-' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman/man1").install_symlink man1/"uu-#{cmd}" => cmd
    end

    (libexec/"uubin").install_symlink "../uuman" => "man"
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^uu-/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"uu-sha1sum", "-c", "test.sha1"
    system bin/"uu-ln", "-f", "test", "test.sha1"
  end
end
