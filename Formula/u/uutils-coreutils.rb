class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.6.0.tar.gz"
  sha256 "f751b8209ec05ae304941a727e42a668dcc45674986252f44d195ed43ccfad2f"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "924e04cc141bcc932b40bc227a08870284fd97e12ef878e708fbda7520fe1221"
    sha256 cellar: :any,                 arm64_sequoia: "c873ce99aeb0582375b6200020d8ed8caf4fda2ad4766b4f61445cc420da714b"
    sha256 cellar: :any,                 arm64_sonoma:  "75840cfa19f39f32d53936f2c87d6f546b86336cef332ab1716347490cb44b65"
    sha256 cellar: :any,                 sonoma:        "30a21dfd48fc8aa7829555b59770b67db8ff303d5218efad2054271a43010bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53fcc66d49a33f9241eea86eb0a99c17100e773c6d6a55fde64bbe27059cf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a495f658272b20d8ded7e0152f10e68932de7b97103c310cc5b5327120884d5"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  # TODO: remove in follow-up to 0.8.0 bump PR
  conflicts_with "unp", because: "both install `ucat` binaries"

  def install
    man1.mkpath

    # Prevent to add a feature for `selinux`
    inreplace "GNUmakefile", "$(SELINUX_PROGS)", ""

    args = %W[
      PROG_PREFIX=uu-
      PREFIX=#{prefix}
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
    ]
    system "make", "install", *args

    # Symlink all commands into libexec/uubin without the 'uu-' prefix
    coreutils_filenames(bin).each do |cmd|
      uu_cmd = bin/"uu-#{cmd}"
      (libexec/"uubin").install_symlink uu_cmd.realpath => cmd

      # Create a temporary compatibility executable for previous 'u' prefix.
      # All users should get the warning in 0.6.0. Similar to brew's odeprecate
      # timeframe, the removal can be done after 2 minor releases, i.e. 0.8.0.
      odie "Remove compatibility exec scripts!" if build.stable? && version >= "0.8.0"
      (bin/"u#{cmd}").write <<~SHELL
        #!/bin/bash
        echo "WARNING: u#{cmd} has been renamed to uu-#{cmd} and will be removed in 0.8.0" >&2
        exec "#{uu_cmd}" "$@"
      SHELL
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
    system bin/"usha1sum", "-c", "test.sha1" # TODO: remove in 0.8.0
    system bin/"uu-sha1sum", "-c", "test.sha1"
    system bin/"uu-ln", "-f", "test", "test.sha1"
  end
end
