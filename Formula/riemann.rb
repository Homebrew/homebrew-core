class Riemann < Formula
  desc "Event stream processor"
  homepage "https://riemann.io/"
  url "https://github.com/riemann/riemann/releases/download/0.3.8/riemann-0.3.8.tar.bz2"
  sha256 "7490c8808c235ca6ba3d96459296dc922840a0a381f02496a4a370ef668a65ef"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "381f8eafa5f3c7be52f321103634ae6ee1d7f61877a5e59a1f7695bc42e96eb2"
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
    system "#{bin}/riemann", "-help", "0"
  end
end
