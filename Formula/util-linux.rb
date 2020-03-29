class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.1.tar.xz"
  sha256 "d9de3edd287366cd908e77677514b9387b22bc7b88f45b83e1922c3597f1d7f9"

  bottle do
    cellar :any
    sha256 "8202113bd4c4c4970eea7e60163c61a8e58a37e76d172df392c1bd04e9414ada" => :catalina
    sha256 "fb15676437f91b315044d8dca6f22e57c93b56df3d6077fb8fc94ffed600972e" => :mojave
    sha256 "fe781f80737fd6353a86d43e485d04694e5147d00e38790bd8c8b45cb9da1591" => :high_sierra
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  keg_only "macOS provides the uuid.h header"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",  # does not build on macOS
                          "--disable-ipcrm", # does not build on macOS
                          "--disable-wall",  # already comes with macOS
                          "--enable-libuuid" # conflicts with ossp-uuid

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
      bash_completion.install prog if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
    end
  end

  test do
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split(" ")
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
