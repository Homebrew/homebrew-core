class Riemann < Formula
  desc "Event stream processor"
  homepage "https://riemann.io/"
  url "https://github.com/riemann/riemann/releases/download/0.3.11/riemann-0.3.11.tar.bz2"
  sha256 "074f5004e5511f1c0f47ba0165abab5cc825c79711fe837b78429586cdd95327"
  license "EPL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d622887f1afb3dc67cc9a03e522516e6d20c418ad2da5eb35b24765293fabb2e"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/riemann", "$top/etc", etc
    etc.install "etc/riemann.config" => "riemann.config.guide"

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    (bin/"riemann").write_env_script libexec/"bin/riemann", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You may also wish to install these Ruby gems:
        riemann-client
        riemann-tools
        riemann-dash
    EOS
  end

  service do
    run [opt_bin/"riemann", etc/"riemann.config"]
    keep_alive true
    log_path var/"log/riemann.log"
    error_log_path var/"log/riemann.log"
  end

  test do
    system bin/"riemann", "-help", "0"
  end
end
