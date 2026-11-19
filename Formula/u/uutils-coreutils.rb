class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.org/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.13.0.tar.gz"
  sha256 "5830c023555ea8e98505e8cfb09524d3097f427c5e58ef197a943e6cb73af9b0"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec0229f0f6159952314f8e4d8953a2148acecb191f6abc2783f4cd2e5ae48e8a"
    sha256 cellar: :any, arm64_tahoe:       "cbbf2c8955c24b37893913b8a037ac070d07d179d0cfbc0fbe2353cd84b5ad61"
    sha256 cellar: :any, arm64_sequoia:     "6adccbb210018edafa8f98327941d187efbc6de164184bbe78976f96f7462f04"
    sha256 cellar: :any, arm64_linux:       "d8c3f00f4d3c8c6b43b15c6839b853d693801da91cea8e382c4ddc4d7607cf3d"
    sha256 cellar: :any, x86_64_linux:      "b94bcdfbe7393333996106267fc2662ec99ba083b4b96f1dd4baaad6c1631854"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
