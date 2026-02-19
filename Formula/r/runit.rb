class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://smarden.org/runit/"
  url "https://smarden.org/runit/runit-2.3.1.tar.gz"
  sha256 "634f23c8c4d1d440043be0fe928ddf904626289e97bfe7c5826e93aaf2cc6fe9"
  license "BSD-3-Clause"

  livecheck do
    url "https://smarden.org/runit/install"
    regex(/href=.*?runit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df648ce12c6d653303f224386961cda0ac9f8b0745fcc41821f671538a28c08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82c5e0878d603839613a0046ccaa773ba88f67acd54290afd77bc01716e0fb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe4f3826fdd17af52828597c22754a6a1e0952a0f2a66179cf572e3858fb82b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e35ad2f49f4b0cf4a0dd60d08c3d071e96a26b87ce4a8bf872e43488794eb4ca"
    sha256                               arm64_linux:   "b54ca8cbb080d15c9eafc949d595dd23d456595a6bfc4f9ef1231f662ea79c74"
    sha256                               x86_64_linux:  "291aed06b55caca42f5af93eec0143d85d2e96db8556a53eb4f9e62b6a84045c"
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
