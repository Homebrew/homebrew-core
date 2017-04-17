class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "http://skinny-framework.org/"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/2.3.6/skinny-2.3.6.tar.gz"
  sha256 "f58402433b5ede9a6a94e95a9bf651b59f67c3b3ae87c04771b371533b0ad4cd"

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
