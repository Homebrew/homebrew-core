class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "a4a7267df27982cf5844e453d59ff866c6daf3ae126bcda05c0abe87dee43b45"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "422fbb319b72f80b329972f0980ddedc0320e7d5376b1b44d8de4e142b371944"
    sha256 cellar: :any,                 arm64_sequoia: "1cb0cbbc58a7bf8575c6e02c88fe8997d89a43115e73de6e1f90f77a3259b7be"
    sha256 cellar: :any,                 arm64_sonoma:  "3cfe91fbb755ce931627711dfd28383c6561bfcb096cd7ef578465eda2c567e6"
    sha256 cellar: :any,                 sonoma:        "f8873255f56222b52a1ae1f36f597bffa2889dc06b9938603b84541537758ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50992381b06287f0dead17e28eb32b242c1606457f474884ef73bcbbe0a01c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcb3754463ba8579c5a912ac2ad299d63957b0731bff3bb570cb17f5d52faf7c"
  end

  depends_on "node" => :build
  depends_on "postgresql@18" => :test
  depends_on "elixir"
  depends_on "erlang"
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    pg_bin = Formula["postgresql@18"].opt_bin
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
