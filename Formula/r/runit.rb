class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "http://smarden.org/runit"
  url "http://smarden.org/runit/runit-2.1.2.tar.gz"
  sha256 "6fd0160cb0cf1207de4e66754b6d39750cff14bb0aa66ab49490992c0c47ba18"

  livecheck do
    url "http://smarden.org/runit/install.html"
    regex(/href=.*?runit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5382dabe0f132590739a602c4f5e5acf54c7aaff32fa0af6800ae8c330e6f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f052bec9af60ed628dec6fd235468b4cbb88d5b02c2570d1e1cddd0596e64be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39e047730d34a1981348cee841295648336b6ff705a200ef5f99130dc0cfde3c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa85ac5365da0fd4ee8e5516b2256dedeaaac2708bd746581863de454ae8aec6"
    sha256 cellar: :any_skip_relocation, monterey:       "80de201022723bb21ff78b50bd6dd1501ea8fb8a4d062e4974ad219d0971d1f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a619f4f93c0a243b27e229916a5c7fc0371c7f38db7a608e5232d27eca9e9987"
    sha256 cellar: :any_skip_relocation, catalina:       "d0e17adfaaf02589b498e362596486515b37a0fda917ee8f0e51ac8e2409afd6"
    sha256 cellar: :any_skip_relocation, mojave:         "ec6f4b2f1b323aba830a5f26daed8615395b0f774de82e074ee699627b1c106a"
    sha256                               x86_64_linux:   "4f36fd98073523f04cebacef60f30fae7501f351c4a885e3a7a4540e41cafb14"
  end

  def install
    # Runit untars to 'admin/runit-VERSION'
    cd "runit-#{version}" do
      # Work around build error from root requirement: "Oops. Your getgroups() returned 0,
      # and setgroups() failed; this means that I can't reliably do my shsgr test. Please
      # either ``make'' as root or ``make'' while you're in one or more supplementary groups."
      inreplace "src/Makefile", "( cat warn-shsgr; exit 1 )", "cat warn-shsgr" if OS.linux?

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

  def caveats
    <<~EOS
      This formula does not install runit as a replacement for init.
      The service directory is #{var}/service instead of /service.

      A system service that runs runsvdir with the default service directory is
      provided. Alternatively you can run runsvdir manually:

           runsvdir -P #{var}/service

      Depending on the services managed by runit, this may need to start as root.
    EOS
  end

  service do
    run [opt_bin/"runsvdir", "-P", var/"service"]
    keep_alive true
    log_path var/"log/runit.log"
    error_log_path var/"log/runit.log"
    environment_variables PATH: "/usr/bin:/bin:/usr/sbin:/sbin:#{opt_bin}"
  end

  test do
    assert_match "usage: #{bin}/runsvdir [-P] dir", shell_output("#{bin}/runsvdir 2>&1", 1)
  end
end
