class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.3.7/skinny-2.3.7.tar.gz"
  sha256 "ce5421354d0518c4e10fba06d63ee8737634bcee73bdafee4fd4dcc5cc737805"

  bottle :unneeded
  depends_on :java => "1.7+"

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
