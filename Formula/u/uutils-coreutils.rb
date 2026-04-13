class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.8.0.tar.gz"
  sha256 "03f765fd23e9cc66f8789edc6928644d8eae5e5a7962d83795739d0a8a85eaef"
  license "MIT"
  revision 1
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3dca4194eb52ee1018d7245b8c8a7e3bd7196c61bfe4efe052f16f53c78b5156"
    sha256 cellar: :any,                 arm64_sequoia: "6f093fbe0c368002408b0b95d3140f18dee0363bb09025a4e0ff698cae92c047"
    sha256 cellar: :any,                 arm64_sonoma:  "79902e7e0b7694995e314b3c3da68168b108035e33caa0e705d05fefb53e0a4e"
    sha256 cellar: :any,                 sonoma:        "03a3427054fceb821c369225b2105bd45e7dff653a10150bc9f43c0a4cf1b2a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d7323360044c84ebc07d70ac0791647c191d4c6ec79abdba2307b1be6ceaf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303487e992bd9bff355d0ef51d8f7d5282fb6337a3f5f9f8f4e937e427b42a9e"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    args = [
      "PROG_PREFIX=uu-",
      "PREFIX=#{prefix}",
      "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build",
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
