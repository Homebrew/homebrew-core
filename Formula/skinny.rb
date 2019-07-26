class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/3.0.3/skinny-3.0.3.tar.gz"
  sha256 "6b4af009f7df8ba21cc54b20b2856a40d201906e09fe75fb528b5241cea515d9"

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
