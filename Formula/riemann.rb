class Riemann < Formula
  desc "Event stream processor"
  homepage "https://riemann.io/"
  url "https://github.com/riemann/riemann/releases/download/0.3.8/riemann-0.3.8.tar.bz2"
  sha256 "3234d4aea762f4aef53e1a4bcd1de5a9d3a234cec896687c1d67f70543abf9bd"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87534de2e2bc2e74014a9728daa350b84e538cbd915c5d2e3da8ddaec0ed9dc7"
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
