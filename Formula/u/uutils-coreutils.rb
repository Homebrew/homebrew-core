class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://github.com/uutils/coreutils/archive/refs/tags/0.5.0.tar.gz"
  sha256 "83535e10c3273c31baa2f553dfa0ceb4148914e9c1a9c5b00d19fbda5b2d4d7d"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ecd5c8b5a9baac32ff72cea0148b6d876529b27e621906ac66261ed165f62307"
    sha256 cellar: :any,                 arm64_sequoia: "7beabd22b863f3a0b859c61926e9feb621a634819e4d4edc52e5f6c21ab542fb"
    sha256 cellar: :any,                 arm64_sonoma:  "04ce2557e67eaeb97cca9f0e833a5153630fe6421b214ab16e1552b897c53947"
    sha256 cellar: :any,                 sonoma:        "bc43f96580b14794f9d6558d9c9d3624825b85a4a47cfea831953557ada76c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d10e01be67fe6a234cf1049113ba45482ce5b5417060e5c979e0ece129e0030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1a2ff2d4d111577c1ae9f1c216bc0e72bd85ad7d86fcfcb11e84e8715deda8"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    # TODO: remove conflict in follow-up CI-syntax-only PR
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  end

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
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", *args

    # Symlink all commands into libexec/uubin without the 'uu-' prefix
    coreutils_filenames(bin).each do |cmd|
      uu_cmd = bin/"uu-#{cmd}"
      (libexec/"uubin").install_symlink uu_cmd.realpath => cmd

      # Fix symlinked commands which require running with non-prefixed name, e.g. sha1sum
      if uu_cmd.symlink?
        rm(uu_cmd)
        bin.write_exec_script libexec/"uubin"/cmd
        bin.install bin/cmd => "uu-#{cmd}"
      end

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

    # Symlink non-conflicting binaries
    no_conflict = %w[hashsum]
    no_conflict.each do |cmd|
      bin.install_symlink "uu-#{cmd}" => cmd
      man1.install_symlink "uu-#{cmd}.1.gz" => "#{cmd}.1.gz"
    end
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
    system bin/"uhashsum", "--sha1", "-c", "test.sha1" # TODO: remove in 0.8.0
    system bin/"uu-hashsum", "--sha1", "-c", "test.sha1"
    system bin/"uu-sha1sum", "-c", "test.sha1"
    system bin/"uu-ln", "-f", "test", "test.sha1"
  end
end
