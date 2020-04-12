class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.6.7/signal-cli-0.6.7.tar.gz"
  sha256 "26a569fd9cb7abb4c7b398a147b1b8b6972cc90faa52ec24a64f256401139f8f"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["lib", "bin"]
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", :err => [:child, :out])
      sleep 8
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "tsdevice:/?uuid=", io.read
  end
end
