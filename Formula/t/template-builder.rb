class TemplateBuilder < Formula
  desc "Shell application designed to streamline the development of new applications"
  homepage "https://github.com/cleverpine/template-builder"
  url "https://github.com/cleverpine/template-builder/releases/download/v1.0.0/template-builder-1.0.0.jar"
  sha256 "003db279b31e00e8e37efb257b33e7b640629d388f28af8b8e38a1ada21c3d1c"
  license "MIT"

  depends_on "openjdk@17"

  def install
    libexec.install "template-builder-#{version}.jar"
    bin.write_jar_script libexec/"template-builder-#{version}.jar", "template-builder"
  end

  test do
    system "#{bin}/template-builder", "--version"
  end
end
