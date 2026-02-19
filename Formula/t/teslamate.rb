class Teslamate < Formula
  desc "Self-hosted data logger for your Tesla"
  homepage "https://docs.teslamate.org"
  url "https://github.com/teslamate-org/teslamate/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9e2b9fca03186ecd2e303d01b4f3810c5e5518d6110ab6f786c60590d4ae1f91"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c3230a3bb12da339cd54b82e78d1243229c7c3c80ae3d7537e2d7f47b7cb19af"
    sha256 cellar: :any,                 arm64_sequoia: "bb2edaeb4f9f5776301e6b17aef20454c766709d4daa40325f0325edb2b2501b"
    sha256 cellar: :any,                 arm64_sonoma:  "5e11bce0b760a92fc3a968a725d3742ab28f38613d770575e6754ff411f4e488"
    sha256 cellar: :any,                 sonoma:        "772f2a3d67f6b02d903e6c8fe63682a6ad2fa19d0425d2369be425070ab0cd44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f47a0ea08520dff99b427004d9ed90d10485cd2971e47eca36db4a54d3aee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5243e5a161d252d0684ea87313227d6f9a2e869229b0151513a93c0fa9e7084"
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
