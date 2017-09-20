class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.5.0/skinny-2.5.0.tar.gz"
  sha256 "1319d98e6ef02d58e63fdf14f37985ba672b4bcb9a672dee379bc6b51e1d1b37"

  bottle :unneeded
  depends_on :java => "1.8+"

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
