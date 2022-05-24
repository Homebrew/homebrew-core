class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "https://skinny-framework.github.io"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/4.0.0/skinny-4.0.0.tar.gz"
  sha256 "7d1370856927e2768c30be15c38dfbd5e322bc6eaf9b5ef14e69ddf2ddc91520"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "136e223ff9658c5d185c911eb0e8a130bb5931814d7a788dd5bfa4f9513d37a7"
  end

  depends_on "openjdk"

  def install
    inreplace %w[skinny skinny-blank-app/skinny], "/usr/local", HOMEBREW_PREFIX
    libexec.install Dir["*"]

    skinny_env = Language::Java.overridable_java_home_env
    skinny_env[:PATH] = "#{bin}:${PATH}"
    skinny_env[:PREFIX] = libexec
    (bin/"skinny").write_env_script libexec/"skinny", skinny_env
  end

  test do
    system bin/"skinny", "new", "myapp"
  end
end
