class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://smarden.org/runit/"
  url "https://smarden.org/runit/runit-2.3.0.tar.gz"
  sha256 "190e11c1f8072b543bb6bd53850555c458d6e306d53df3fc1232d300c3e21b51"
  license "BSD-3-Clause"

  livecheck do
    url "https://smarden.org/runit/install"
    regex(/href=.*?runit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "740a71a530fd2b232d9f748242f754f83b6539413e0d66a6f6c71a3ee05b7bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0cdcfc77c6aa021cefdb6b7912cf2ea2f4b7f3b983e6773d9b5db50ead2e6e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8523d16c2e695d31be790e2da2a5be482ad8455f9212b5b2346671b6f7a7981"
    sha256 cellar: :any_skip_relocation, sonoma:        "234f9ceca1568e80014aad5e5361c34b70dd90b327931978117fe7e85563cd3e"
    sha256                               arm64_linux:   "85a69d7aa280e9052c20ae0b6b4e2614cb317ae5639d0cbe266766b622b2d693"
    sha256                               x86_64_linux:  "f4761f4ef955b6c445a241e14f48d3180d8f65d10f2df79eeb7d62debd6ac524"
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
