class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv#readme"
  url "https://github.com/xcenv/xcenv/archive/v1.0.4.tar.gz"
  sha256 "cac6e5475b0dda35fe1c3771bc60b703e0df7b87b1bf607988c447768ca02122"
  head "https://github.com/xcenv/xcenv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bdcf774eebbfa075bf539c44ee4469a8d3d7b0f326c475ec8654d61a2647429" => :sierra
    sha256 "cea5afaa85e626275f25897176165839ce8b62e83e6858a6d2733e5aa2a08b4e" => :el_capitan
    sha256 "82c0673fec7ade22f064e2d8f67739b4e1c86c4b86cfe0d89bf8561b82978565" => :yosemite
    sha256 "82c0673fec7ade22f064e2d8f67739b4e1c86c4b86cfe0d89bf8561b82978565" => :mavericks
  end

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
