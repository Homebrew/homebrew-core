class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.xz"
  sha256 "86e6707a379c7ff5489c218cfaf1e3464b0b95acf7817db0bc5f179e356a67b2"

  bottle do
    cellar :any
    sha256 "8ff96bb1e4e04a8df26e0d062e855e0a83f4f6afe437c0fecca2ba0b891ac3e5" => :high_sierra
    sha256 "353016648e93cdaf7e9d277c0e7e26b3c681b19ccc6f87faa79996100de0925d" => :sierra
    sha256 "7d29b310f3bf5228b702031923ab8877ddaadaf46120ccf577d8b5ee9ca77e00" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
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
      rm_f share/"bash-completion"/"completions"/prog
    end
  end

  test do
    out = shell_output("#{bin}/namei -lx /usr").split("\n")
    assert_equal ["f: /usr", "Drwxr-xr-x root wheel /", "drwxr-xr-x root wheel usr"], out
  end
end
