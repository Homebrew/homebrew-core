class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "508dea91bfcd331d3acfbde90b3e7fe4c5755bb4b8080577053cd8f111f4c3d1"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c2b6b81913b478919a272635f32cb49b1a3f42b2ad32973788245625763c522c"
    sha256 cellar: :any, arm64_sequoia: "8708c52ad2195f401ae551fda328d243526ef8d7da20ac9bdf7435b7e373fbf3"
    sha256 cellar: :any, arm64_sonoma:  "62db33e7bd1cb265b103838a28f5199cbd8c5a6a914b2c2f8724e6172fdb4158"
    sha256 cellar: :any, sonoma:        "7104643be2adf2f809e4809ce12b5e5fe45c89ad696761ff1d7b77319184a755"
    sha256 cellar: :any, arm64_linux:   "773309a92574ff0eadeac2f6c9350a0b1a6382a2441eb34ef5fa036ac050db53"
    sha256 cellar: :any, x86_64_linux:  "34d227f71557a1ff5d4ec89241a75fdf10606b76593dfe8e27a34efb986ce520"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "node" => :build
  depends_on "postgresql@18" => :test
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
    (bin/"teslamate_brew_services").write <<~BASH
      #!/bin/bash
      set -e
      source #{etc}/teslamate.env
      #{bin}/teslamate eval "TeslaMate.Release.migrate"
      exec #{bin}/teslamate start
    BASH
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
    pg_bin = formula_opt_bin("postgresql@18")
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
