class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.33/util-linux-2.33.2.tar.xz"
  sha256 "631be8eac6cf6230ba478de211941d526808dba3cd436380793334496013ce97"

  bottle do
    cellar :any
    sha256 "e3a2f8a25014834e994e1e1316c182d7980ffa2e701d838c3c4ad4a495034c70" => :mojave
    sha256 "3da928faa6d5dcd4aaaeff0a0c3f909d16dde253375bf7f5328924ff946006c1" => :high_sierra
    sha256 "02c15639cc3e40c7553dbcb23e94a5e679feeaad8881ed6ddce91c4cb0a015b2" => :sierra
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
