class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "a4a7267df27982cf5844e453d59ff866c6daf3ae126bcda05c0abe87dee43b45"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "365e32212184579cd3ad2e8645994e88d5a2d19e5bf46ac32ebcab53ff0f1b99"
    sha256 cellar: :any,                 arm64_sequoia: "a009b56e79cab4ad8ab6cc93a724009b905fedc6c16b719ab99355105d7be9bd"
    sha256 cellar: :any,                 arm64_sonoma:  "051fee5157e21481b9365da64058189babfb80efe0f53a15110244734b42913d"
    sha256 cellar: :any,                 sonoma:        "c761eaccdc2122fb4544aa9521e9b7d5d4e411a34907228fd60c13e8966cf03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b5037040201b926c88283fa5f582fbd638f78744fbd66586aa3b4b477097d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15897cb1032f908f271565db40062499ee6fb30b4793a657600c559470ec242b"
  end

  depends_on "node" => :build
  depends_on "postgresql@18" => :test
  depends_on "elixir"
  depends_on "erlang"
  depends_on "openssl@3"

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
