class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "1f928cfeb788f0451fca80fd53e7e57afce882e479392cec0dd034aa6f2ce610"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0899d0dc63b15f12c67cad629b1a69bba04809fe47faa0e7c4aa935508899b64"
    sha256 cellar: :any, arm64_tahoe:       "4e90bff20f1097562212b80f121deb2f4affbc3cd5ffa97388d22fee145a7258"
    sha256 cellar: :any, arm64_sequoia:     "dcb6cd9cda8498b5137daa705c6887d1d3bf511c789346370e47f7430240b8d2"
    sha256 cellar: :any, arm64_linux:       "bc95e769e055e66c1bea1c5c6e41e7a48852f0820b08dc5b03c893f5ab510eca"
    sha256 cellar: :any, x86_64_linux:      "52ec83566b717988a3b6b7e4ea468aa47d3ce28419c68de8560f951d9b5e4768"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "node" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # See https://docs.teslamate.org/docs/installation/unsupported/debian
    cd "elixir"
    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get", "--only", "prod"
    system "npm", "install", "--prefix", "./assets", *std_npm_args(prefix: false)
    system "npm", "run", "deploy", "--prefix", "./assets"

    with_env("MIX_ENV" => "prod") do
      system "mix", "do", "phx.digest,", "release", "--overwrite"
    end

    touch "teslamate.env"
    etc.install "teslamate.env"
    libexec.install Dir["_build/prod/rel/teslamate/*"]
    bin.install_symlink Dir["#{libexec}/bin/teslamate"]

    # Corresponds to https://github.com/teslamate-org/teslamate/blob/main/entrypoint.sh
    (bin/"teslamate_brew_services").write <<~BASH
      #!/bin/bash
      set -e
      source #{etc}/teslamate.env
      #{bin}/teslamate eval "TeslaMate.Release.migrate"
      exec #{bin}/teslamate start
    BASH

    # Use brewed ca-certificates PEM file instead of the bundled copy
    cacerts = libexec.glob("lib/castore-*/priv/cacerts.pem").fetch(0)
    rm cacerts
    cacerts.make_relative_symlink Formula["openssl@4"].pkgetc/"cert.pem"
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
    pg_bin = dep("postgresql").opt_bin
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
      endpoint_message = "Access TeslaMateWeb.Endpoint at http://localhost"

      File.open(log_file, "w") do |file|
        pid = spawn(opt_bin/"teslamate_brew_services", out: file, err: file)
        sleep 1 until log_file.read.include?(endpoint_message)
        system opt_bin/"teslamate", "stop"
        Process.kill("KILL", pid)
        Process.wait(pid)
      end
      assert_match endpoint_message, log_file.read
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
