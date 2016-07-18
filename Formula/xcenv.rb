class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv#readme"
  url "https://github.com/xcenv/xcenv/archive/v1.0.0.tar.gz"
  sha256 "257fbb6c13aa434142a5b74686114eb432b6f0f005a6127aa53b1c2628870d39"
  head "https://github.com/xcenv/xcenv.git"

  def install
    prefix.install ["bin", "libexec"]
  end

  def caveats; <<-EOS.undent
    Xcenv stores data under ~/.xcenv by default. If you absolutely need to
    store everything under Homebrew's prefix, include this in your profile:
      export XCENV_ROOT=#{var}/xcenv
    To enable shims and autocompletion, run this and follow the instructions:
      xcenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
