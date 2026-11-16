class Rabbitmq < Formula
  desc "Messaging and streaming broker"
  homepage "https://www.rabbitmq.com"
  url "https://github.com/rabbitmq/rabbitmq-server/releases/download/v4.4.1/rabbitmq-server-generic-unix-4.4.1.tar.xz"
  sha256 "667c652c1cb272c02f8a25b1ef32e981661f358b399a9d5c227982cc2101390f"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08b4a8490b9223cf492ad11de28fb50e657e57af7d6fc482ac1b3e7fd3fc1136"
  end

  depends_on "erlang"

  uses_from_macos "python" => :build

  allow_network_access! :test

  def erlang = deps.map(&:name).find { |d| d.match?(/^erlang(@\d+(\.\d+)*)?$/) }

  def install
    # Install the base files
    prefix.install Dir["*"]

    # Setup the lib files
    (var/"lib/rabbitmq").mkpath

    # Correct SYS_PREFIX for things like rabbitmq-plugins
    inreplace sbin/"rabbitmq-defaults" do |s|
      s.gsub! "SYS_PREFIX=${RABBITMQ_HOME}", "SYS_PREFIX=#{HOMEBREW_PREFIX}"
      s.gsub! "CLEAN_BOOT_FILE=start_clean", "CLEAN_BOOT_FILE=#{formula_opt_lib(erlang)/"erlang/bin/start_clean"}"
      s.gsub! "SASL_BOOT_FILE=start_sasl", "SASL_BOOT_FILE=#{formula_opt_lib(erlang)/"erlang/bin/start_clean"}"
    end

    # Set RABBITMQ_HOME in rabbitmq-env
    inreplace sbin/"rabbitmq-env",
              'RABBITMQ_HOME="$(rmq_realpath "${RABBITMQ_SCRIPTS_DIR}/..")"',
              "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc/"rabbitmq/rabbitmq-env.conf"
    rabbitmq_env_conf.write <<~ENV unless rabbitmq_env_conf.exist?
      CONFIG_FILE=#{etc}/rabbitmq/rabbitmq
      NODE_IP_ADDRESS=127.0.0.1
      NODENAME=rabbit@localhost
      RABBITMQ_LOG_BASE=#{var}/log/rabbitmq
      PLUGINS_DIR="#{opt_prefix}/plugins:#{HOMEBREW_PREFIX}/share/rabbitmq/plugins"
    ENV

    # Enable plugins - management web UI; STOMP, MQTT, AMQP 1.0 protocols
    enabled_plugins_path = etc/"rabbitmq/enabled_plugins"
    unless enabled_plugins_path.exist?
      enabled_plugins_path.write "[rabbitmq_management,rabbitmq_stomp,rabbitmq_amqp1_0," \
                                 "rabbitmq_mqtt,rabbitmq_stream]."
    end
  end

  def caveats
    <<~EOS
      Management UI: http://localhost:15672
      Homebrew-specific docs: https://rabbitmq.com/install-homebrew.html
    EOS
  end

  service do
    run opt_sbin/"rabbitmq-server"
    log_path var/"log/rabbitmq/std_out.log"
    error_log_path var/"log/rabbitmq/std_error.log"
    # need erl in PATH
    environment_variables PATH:          "#{HOMEBREW_PREFIX}/sbin:/usr/sbin:/usr/bin:/bin:#{HOMEBREW_PREFIX}/bin",
                          CONF_ENV_FILE: etc/"rabbitmq/rabbitmq-env.conf"
  end

  test do
    ENV["RABBITMQ_MNESIA_BASE"] = testpath/"var/lib/rabbitmq/mnesia"
    ENV["RABBITMQ_CONFIG_FILE"] = testpath/"rabbitmq.conf"

    mqtt_port = free_port
    (testpath/"rabbitmq.conf").write <<~CONF
      mqtt.listeners.tcp.default=#{mqtt_port}
    CONF

    pid = spawn sbin/"rabbitmq-server"
    system sbin/"rabbitmq-diagnostics", "wait", "--pid", pid
    system sbin/"rabbitmqctl", "status"
    system sbin/"rabbitmqctl", "stop"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
