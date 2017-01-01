class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.3.3/skinny-2.3.3.tar.gz"
  sha256 "e743d3ddcd4c6c6fe762dfe56eb1e1d06ad3739d10b072c0847982ec5832efe5"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    (bin/"skinny").write <<-EOS.undent
      #!/bin/bash
      export PATH=#{bin}:$PATH
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
