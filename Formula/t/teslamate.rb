class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "25787bbf785fa623e8d54ecd39976af737c8bff9aaa9b581bf9d7254c9defcaa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87ff93fad948ad249b3e18922d4f8196177d1d9ac4b7744d8083459968e000d4"
    sha256 cellar: :any,                 arm64_sequoia: "7c204f36cabb2d89dddf6f7d818b305b29598ec220d4343cb25d051fec4c4040"
    sha256 cellar: :any,                 arm64_sonoma:  "376137b668590f52bd25dfafcbce56a83a9e677de2f20a223f1aca3e6f21f4a8"
    sha256 cellar: :any,                 arm64_ventura: "4e7cbcb7595ee69a10af1da9231ed37bf8fe79174a88ae22851908fb1dc5e742"
    sha256 cellar: :any,                 sonoma:        "b0c19c28d0094cbeb0dfd9ffdedf330513ea6a4a31a1cfcf4614db6963de4563"
    sha256 cellar: :any,                 ventura:       "0aee63b55d7bfc4593fac0b52a17dd24741f2713d282267b5a48dd97f0c1cc57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5be50a032e3597e5bd0b49b8f20adacd461b8703ac73af4dec6699290679b4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbd202552ff94068a7f6ee70827060adefc9ab36ddcb542111d71b8fbbaa75bb"
  end

  depends_on "node" => :build
  depends_on "postgresql@17" => :test
  depends_on "elixir"
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # See https://docs.teslamate.org/docs/installation/debian/
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get", "--only", "prod"
    system "npm", "install", "--prefix", "./assets", *std_npm_args(prefix: false)
    system "npm", "run", "deploy", "--prefix", "./assets"

    with_env("MIX_ENV" => "prod") do
      system "mix", "do", "phx.digest,", "release", "--overwrite"
    end

    touch buildpath/"teslamate.env"
    etc.install "teslamate.env"
    libexec.install Dir["_build/prod/rel/teslamate/*"]
    bin.install_symlink Dir["#{libexec}/bin/teslamate"]

    # Corresponds to https://github.com/teslamate-org/teslamate/blob/main/entrypoint.sh
    (bin/"teslamate_brew_services").write <<~EOS
      #!/bin/bash
      set -e
      source #{etc}/teslamate.env
      #{bin}/teslamate eval "TeslaMate.Release.migrate"
      exec #{bin}/teslamate start
    EOS
  end

  service do
    run opt_bin/"teslamate_brew_services"
    keep_alive true
    log_path var/"log/teslamate.log"
    error_log_path var/"log/teslamate.log"
    working_dir var
  end

  test do
    ENV["LC_ALL"] = "C"

    pg_port = free_port
    pg_bin = Formula["postgresql@17"].opt_bin
    pg_ctl = pg_bin/"pg_ctl"
    datadir = testpath/"postgres"
    system pg_ctl, "init", "-D", datadir

    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{pg_port}
      unix_socket_directories = '#{datadir}'
    EOS

    system pg_ctl, "start", "-D", datadir, "-l", testpath/"postgres.log"
    begin
      system pg_bin/"createdb", "-h", datadir, "-p", pg_port.to_s, "teslamate"
      system pg_bin/"createuser", "-h", datadir, "-p", pg_port.to_s, "-s", "teslamate"

      # Run Teslamate with the test database
      ENV["DATABASE_USER"] = "teslamate"
      ENV["DATABASE_PASS"] = ""
      ENV["DATABASE_NAME"] = "teslamate"
      ENV["DATABASE_HOST"] = "127.0.0.1"
      ENV["DATABASE_PORT"] = pg_port.to_s
      ENV["DISABLE_MQTT"] = "true"
      log_file = testpath/"teslamate_test.log"
      File.open(log_file, "w") do |file|
        pid = spawn(opt_bin/"teslamate_brew_services", out: file, err: file)
        sleep 20
        system opt_bin/"teslamate", "stop"
        Process.kill("KILL", pid)
        Process.wait(pid)
      end
      output = log_file.read
      assert_match "Access TeslaMateWeb.Endpoint at http://localhost", output
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
