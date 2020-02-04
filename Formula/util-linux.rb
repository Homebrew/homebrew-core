class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-2.35.1.tar.xz"
  sha256 "d9de3edd287366cd908e77677514b9387b22bc7b88f45b83e1922c3597f1d7f9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ad4962d8ce56d784085cf53e2f3add3432a3905285acf05a23fcc2e5e40cf5a8" => :catalina
    sha256 "483548a881703f1e4645c40a9779758ff2da0db1dc521b4ce7321d86c723669d" => :mojave
    sha256 "f02d33204d3ff42112ab972d1fa93f84a7676bcc28f208eac41172db4f7416e7" => :high_sierra
  end

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
      if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
        bash_completion.install prog
      end
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
