class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/3.0.2/skinny-3.0.2.tar.gz"
  sha256 "077b626f9591e31e8cfe87b5e46ae85074c1fd50c518ad3eb8c3681ef738872b"

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
