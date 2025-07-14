class Runit < Formula
  desc "Collection of tools for managing UNIX services"
  homepage "https://smarden.org/runit/"
  url "https://smarden.org/runit/runit-2.2.0.tar.gz"
  sha256 "95ef4d2868b978c7179fe47901e5c578e11cf273d292bd6208bd3a7ccb029290"
  license "BSD-3-Clause"

  livecheck do
    url "https://smarden.org/runit/install"
    regex(/href=.*?runit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c6d9fe18b8ab5e4f85de166d9300367cbdb8c4157ae7ba26d6f891376bb248d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48a87a97472f98638753b03e3a9fd5aa6b622cbd59c114c1ab3b4b2dca4158f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a02febc253e32ca872f45183b70298c703b86a69d756850170b10454f921efcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f820d9806a8247bd514c135b926100b205fa13aaded0f77ef73c22156ebd8309"
    sha256 cellar: :any_skip_relocation, ventura:       "2fb88364202380b041df206331f369cd8b90cb7b38407e83195ab5c5cecb4d6f"
    sha256                               arm64_linux:   "86e7afab38bcc1a78ed0652367ca988d2c3fa33fc3a2b9456d689ece9cd067da"
    sha256                               x86_64_linux:  "84004a0ce4e354a57c901166bfd58276a281c22f56fccae2690b3c7c158f055d"
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
