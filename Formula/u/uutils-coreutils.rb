class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.9.0.tar.gz"
  sha256 "dafe0126ee4ed55c7cd60c6b559f43724a74751deed3c1b078f4f510311acab2"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "27ecf2c1a51c1d3d5c67f4b3ac500dd025e6313da28fb06d5b7581b451b25db1"
    sha256 cellar: :any, arm64_sequoia: "d4db7458e28c3c734ad7464fa8b4054a81eaf72f013ab62cbdc66445231bf212"
    sha256 cellar: :any, arm64_sonoma:  "15ba4294d5e6888fce1fa8896010a19bb29120a5a16542e96dede46565b923b6"
    sha256 cellar: :any, sonoma:        "f2bde95fd1e238cf67ea2086e6a1607d67a1713f5c49a700650f78c56d2e8242"
    sha256 cellar: :any, arm64_linux:   "d67bcf18226fd103a0f51f14820f08e25d3f5c0b54ec7898a5b94414feb8cbd1"
    sha256 cellar: :any, x86_64_linux:  "1957325110ada226f799121f1070ed2e24a4c7edea87ecf673ed150ca927d24d"
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
