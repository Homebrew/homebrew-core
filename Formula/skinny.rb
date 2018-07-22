class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/3.0.0-RC1/skinny-3.0.0-RC1.tar.gz"
  sha256 "c7873beeb475e60b3e1277451a5beeda297eeb6937954b56dc3757e167c96902"

  bottle :unneeded
  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (bin/"skinny").write <<~EOS
      #!/bin/bash
      export PATH=#{bin}:$PATH
      PREFIX="#{libexec}" exec "#{libexec}/skinny" "$@"
    EOS
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
