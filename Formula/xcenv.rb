class Xcenv < Formula
  desc "Xcode version manager"
  homepage "http://xcenv.org"
  url "https://github.com/xcenv/xcenv/archive/v1.1.0.tar.gz"
  sha256 "3a08afad39bf8243769b7aa49597688a8418ded9c229f672a3af8b007db4d331"
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

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
