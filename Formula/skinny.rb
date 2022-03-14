class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/4.0.0/skinny-4.0.0.tar.gz"
  sha256 "7d1370856927e2768c30be15c38dfbd5e322bc6eaf9b5ef14e69ddf2ddc91520"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3599c215671ecb68ec4f067b69d130635d3b10fb3e28c562641683886ba02d13"
  end

  depends_on "openjdk"

  def install
    inreplace %w[skinny skinny-blank-app/skinny], "/usr/local", HOMEBREW_PREFIX
    libexec.install Dir["*"]
    (bin/"skinny").write <<~EOS
      #!/bin/bash
      export PATH=#{bin}:$PATH
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
