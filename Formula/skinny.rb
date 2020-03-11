class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/3.1.0/skinny-3.1.0.tar.gz"
  sha256 "4c5661f73bda7d5ccb5a8966efe801951e2a343cf152ac6e9a06d287c5c8712d"

  bottle :unneeded
  depends_on "openjdk"

  def install
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
