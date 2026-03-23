class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.7.0.tar.gz"
  sha256 "dc56a3c4632742357d170d60a7dcecb9693de710daeaafa3ad925750b1905522"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59d7fc0df88ced1afca1745149671efd09c0bc4199ef6b85d7fc880be5824850"
    sha256 cellar: :any,                 arm64_sequoia: "ce36b9388e0b2aa9430c6db15f9d010a89d989d0da8467067ba8099313697c5c"
    sha256 cellar: :any,                 arm64_sonoma:  "2b03e93d33ddfecb81550d393d467b9775cc705bb8ff87d2a053148bd2e40fcf"
    sha256 cellar: :any,                 sonoma:        "8dd12b9a70865c41532a83d551eedd319108bbf6d0b2c8d9adbef3fa32825bbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b3d9fe5447b3be3d26d528b0c19f9b0ce95a1639c9e6f19f3297b94d552ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e14b9304ce344ca444d8fe1533e152949a97ceeb80410604515f3b5f2fbfff0"
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
