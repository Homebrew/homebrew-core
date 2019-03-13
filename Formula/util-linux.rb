class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"
  revision 1

  bottle do
    cellar :any
    sha256 "977cf2845acc9cdcbcf1b7e92d9c0af0066c5d0cc17df307a123c13180a64e62" => :mojave
    sha256 "d551dad77ab8c533bab98d5bd91291db1f296564336d59d600f0ce75496a9d08" => :high_sierra
    sha256 "aeef9c88dd7ea82ac3f71b6f3793b2316b76ee59a8e01cc56f6316efa4e1346c" => :sierra
    sha256 "f3040a39ad4ffb9eabd9446843dfc3b66df01b3264c875dc68e7339636830357" => :el_capitan
  end

  conflicts_with "rename", :because => "both install `rename` binaries"

  def noshadow
    list =%w[ipcmk isosize mcookie namei rename scriptreplay setsid]
    list
  end

  def noshadow_sbin
    list =%w[blkid findfs fsck.cramfs fsck.minix mkfs mkfs.bfs mkfs.cramfs mkfs.minix mkswap swaplabel]
    list
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--program-prefix=l",
                          "--disable-ipcs",        # does not build on macOS
                          "--disable-ipcrm",       # does not build on macOS
                          "--disable-wall",        # already comes with macOS
                          "--disable-libuuid"      # conflicts with ossp-uuid

    system "make", "install"

    # Binaries not shadowing macOS utils symlinked without 'l' prefix
    # install completions only for installed programs
    noshadow.each do |cmd|
      bin.install_symlink "l#{cmd}" => cmd
      man1.install_symlink "l#{cmd}.1" => "#{cmd}.1"
      bash_completion.install cmd
    end

    # Binaries not shadowing macOS utils symlinked without 'l' prefix
    # install completions only for installed programs
    noshadow_sbin.each do |cmd|
      sbin.install_symlink "l#{cmd}" => cmd
      man1.install_symlink "l#{cmd}.1" => "#{cmd}.1"
      bash_completion.install cmd
    end

    # Symlink commands without 'g' prefix into libexec/gnubin and
    # man pages into libexec/gnuman
    bin.find.each do |path|
      next unless File.executable?(path) && !File.directory?(path)

      cmd = path.basename.to_s.sub(/^l/, "")
      (libexec/"gnubin").install_symlink bin/"l#{cmd}" => cmd
      (libexec/"gnuman"/"man1").install_symlink man1/"l#{cmd}.1" => "#{cmd}.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    The following commands have been installed without the prefix 'l'.

        #{noshadow.sort.join("\n    ")}
        #{noshadow_sbin.sort.join("\n    ")}

    The rest of commands have been installed with the prefix to avoid shadowing
    existing macOS commands. If you really need to use the rest of the commands
    with their normal names, you can add a "gnubin" directory to your PATH from
    your bashrc like:

        PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
