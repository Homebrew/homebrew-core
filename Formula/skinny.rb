class Skinny < Formula
  desc "Full-stack web app framework in Scala"
  homepage "https://skinny-framework.github.io"
  url "https://github.com/skinny-framework/skinny-framework/releases/download/4.0.0/skinny-4.0.0.tar.gz"
  sha256 "7d1370856927e2768c30be15c38dfbd5e322bc6eaf9b5ef14e69ddf2ddc91520"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3599c215671ecb68ec4f067b69d130635d3b10fb3e28c562641683886ba02d13"
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
