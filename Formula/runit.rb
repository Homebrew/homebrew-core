class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "http://smarden.org/runit"
  url "http://smarden.org/runit/runit-2.1.2.tar.gz"
  sha256 "6fd0160cb0cf1207de4e66754b6d39750cff14bb0aa66ab49490992c0c47ba18"

  bottle do
    sha256 "e70c75527e992d70255d13631b56e7f1629cb1dc3583881967c6f4468fd296ef" => :mojave
    sha256 "6f5e25b4f9d7d9128726aa72f97fda3b480cd36a5002041210e11303811f2369" => :high_sierra
    sha256 "4eefe737db7b327dd6c595f57f34a8b564e170427ffc24ab35c4cd5ee79a6ec1" => :sierra
    sha256 "3dbc4f1ba3d86e5f3d6900a19ff90b32d2aff91ffb68914be8740d916f3622da" => :el_capitan
    sha256 "c268f70014699ba6be9a198686547ddd150f0b779aa0a1e623df60068d8cd4be" => :yosemite
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
      rcmds = File.read("package/commands")

      rcmds.split("\n").each do |r|
        bin.install("command/#{r.chomp}")
        man8.install("man/#{r.chomp}.8")
      end

      (var + "service").mkpath
    end
  end

  def caveats; <<~EOS
    This formula does not install runit as a replacement for init.
    The service directory is #{var}/service instead of /service.

    To have runit ready to run services, start runsvdir:
         runsvdir -P #{var}/service

    Depending on the services managed by runit, this may need to start as root.
  EOS
  end
end
