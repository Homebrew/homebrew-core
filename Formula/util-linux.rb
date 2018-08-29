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

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",        # does not build on macOS
                          "--disable-ipcrm",       # does not build on macOS
                          "--disable-wall",        # already comes with macOS
                          "--disable-libuuid",     # conflicts with ossp-uuid
                          "--disable-libsmartcols" # macOS already ships 'column'

    system "make", "install"

    # Remove binaries already shipped by macOS
    %w[cal col colcrt colrm getopt hexdump logger nologin look mesg more renice rev ul whereis].each do |prog|
      rm_f bin/prog
      rm_f sbin/prog
      rm_f man1/"#{prog}.1"
      rm_f man8/"#{prog}.8"
      rm_f share/"bash-completion/completions/#{prog}"
    end

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
        bash_completion.install prog
      end
    end
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
