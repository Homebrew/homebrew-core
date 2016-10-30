class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "http://smarden.org/runit"
  url "http://smarden.org/runit/runit-2.1.1.tar.gz"
  sha256 "ffcf2d27b32f59ac14f2d4b0772a3eb80d9342685a2042b7fbbc472c07cf2a2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "96c9f9a556f96b8d35330775f105da390f60c332b655d292ba81c91d62d37725" => :sierra
    sha256 "aad8b537d84c9219b6d836aefe02e549f55f4f55183c6bf668efc3d68070f8f7" => :el_capitan
    sha256 "6558d24d895cd976cd9f23d7bf76ae2de40040017be2577061d6de9fbd35d1f3" => :yosemite
    sha256 "1bed0d534c4880367cf119707f17a38bf0cc4fb0b3b15409b7306e3eb4a6b219" => :mavericks
  end

  def install
    # Runit untars to 'admin/runit-VERSION'
    cd "runit-#{version}" do
      # Per the installation doc on macOS, we need to make a couple changes.
      system "echo 'cc -Xlinker -x' >src/conf-ld"
      inreplace "src/Makefile", / -static/, ""

      inreplace "src/sv.c", "char *varservice =\"/service/\";", "char *varservice =\"#{var}/service/\";"
      system "package/compile"

      # The commands are compiled and copied into the 'command' directory and
      # names added to package/commands. Read the file for the commands and
      # install them in homebrew.
      rcmds = File.open("package/commands").read

      rcmds.split("\n").each do |r|
        bin.install("command/#{r.chomp}")
        man8.install("man/#{r.chomp}.8")
      end

      (var + "service").mkpath
    end
  end

  def caveats; <<-EOS.undent
    This formula does not install runit as a replacement for init.
    The service directory is #{var}/service instead of /service.

    To have runit ready to run services, start runsvdir:
         runsvdir -P #{var}/service

    Depending on the services managed by runit, this may need to start as root.
    EOS
  end
end
