class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.3.8/skinny-2.3.8.tar.gz"
  sha256 "ad455cd92d06978c2bbf2d327c9ce277191bf53bdfc2e9f77bbb0f94f177c6cd"

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
