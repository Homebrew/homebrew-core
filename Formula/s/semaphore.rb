class Semaphore < Formula
  desc "Modern UI and powerful API for Ansible, Terraform, OpenTofu, PowerShell"
  homepage "https://semaphoreui.com"
  url "https://github.com/semaphoreui/semaphore/archive/refs/tags/v2.20.24.tar.gz"
  sha256 "f408e9410f316385fe624c994cb9a398b0eac2ece1bc5cb728c553205d9da928"
  license "MIT"
  head "https://github.com/semaphoreui/semaphore.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # The test starts the server and connects to it over localhost.
  deny_network_access! [:build, :postinstall]

  def fetch
    system "go", "mod", "download"
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    cd "web" do
      system "npm", "--offline", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/semaphoreui/semaphore/util.Ver=#{version}
      -X github.com/semaphoreui/semaphore/util.Commit=#{tap.user}
      -X github.com/semaphoreui/semaphore/util.Date=#{time.to_i}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "./cli"

    generate_completions_from_executable(bin/"semaphore", shell_parameter_format: :cobra)

    # Writes the default config with secrets unique to this installation;
    # post_install_steps can only take literal arguments, so it can't make them.
    (libexec/"semaphore-init-config").write <<~SH
      #!/bin/sh
      # Usage: semaphore-init-config <config.json> <data dir>
      set -eu
      config="$1"
      data_dir="$2"
      [ -e "$config" ] && exit 0

      secret() { head -c 32 /dev/urandom | base64 | tr -d '\\n'; }

      umask 077
      mkdir -p "$(dirname "$config")" "$data_dir/tmp"
      cat > "$config" <<EOF
      {
        "dialect": "sqlite",
        "sqlite": {
          "host": "$data_dir/database.sqlite"
        },
        "interface": "127.0.0.1",
        "port": ":3000",
        "tmp_path": "$data_dir/tmp",
        "cookie_hash": "$(secret)",
        "cookie_encryption": "$(secret)",
        "access_key_encryption": "$(secret)"
      }
      EOF
    SH
    chmod 0755, libexec/"semaphore-init-config"
  end

  post_install_steps do
    mkdir_p "semaphore/tmp", base: :var
    mkdir_p "log", base: :var
    unless_path_exists "semaphore/config.json", base: :etc do
      run "semaphore-init-config", args: ["{{etc}}/semaphore/config.json", "{{var}}/semaphore"], base: :libexec
    end
  end

  def caveats
    <<~EOS
      A config with freshly generated encryption keys was created at
        #{etc}/semaphore/config.json
      Back it up: without access_key_encryption, stored secrets can't be decrypted.

      The web UI listens on http://127.0.0.1:3000 by default.
      Change "interface" and "port" in the config to expose it on the network.

      Create the first admin user before signing in:
        semaphore user add --admin --login admin --name Admin \\
          --email admin@localhost --password <password> \\
          --config #{etc}/semaphore/config.json

      Semaphore runs tools from PATH; install the ones you need, e.g.:
        brew install ansible opentofu
    EOS
  end

  service do
    run [opt_bin/"semaphore", "server", "--config", etc/"semaphore/config.json"]
    environment_variables PATH: std_service_path_env
    keep_alive true
    working_dir var/"semaphore"
    log_path var/"log/semaphore.log"
    error_log_path var/"log/semaphore.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/semaphore version")

    config = testpath/"etc/config.json"
    system libexec/"semaphore-init-config", config, testpath/"data"
    assert_equal "sqlite", JSON.parse(config.read)["dialect"]

    system bin/"semaphore", "user", "add", "--admin", "--login", "admin", "--name", "Admin",
           "--email", "admin@example.com", "--password", "password", "--config", config
    assert_match "admin", shell_output("#{bin}/semaphore user list --config #{config}")

    port = free_port
    pid = spawn({ "SEMAPHORE_PORT" => port.to_s }, bin/"semaphore", "server", "--config", config)
    begin
      sleep 5
      assert_equal "pong", shell_output("curl -s http://127.0.0.1:#{port}/api/ping")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
