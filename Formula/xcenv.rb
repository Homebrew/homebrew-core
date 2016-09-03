class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv#readme"
  url "https://github.com/xcenv/xcenv/archive/v1.0.4.tar.gz"
  sha256 "cac6e5475b0dda35fe1c3771bc60b703e0df7b87b1bf607988c447768ca02122"
  head "https://github.com/xcenv/xcenv.git"

  def install
    prefix.install ["bin", "libexec"]
  end

  def caveats; <<-EOS.undent
    Xcenv stores data under ~/.xcenv by default. If you absolutely need to
    store everything under Homebrew's prefix, include this in your profile:
      export XCENV_ROOT=#{var}/xcenv
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
