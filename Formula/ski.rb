class Ski < Formula
  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.13.tar.gz"
  sha256 "34e95547ecfe7b3791df0a81fef9af422ececf49b1aa1e93bbb1ba067ccdc955"
  license "BSD-2-Clause"

  head do
    url "https://gitlab.com/esr/ski.git"
    depends_on "xmlto" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6032ccdfd57a414c4c7336aee66c03416b549ffba4aa9de2e5f456e7666b27ae" => :big_sur
    sha256 "80da0faf28f34d0440e89fa1761ad91e46be161925f42d6f3cfe6e2f74e718a3" => :arm64_big_sur
    sha256 "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253" => :catalina
    sha256 "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253" => :mojave
    sha256 "b647b2162475b1dccee3afe7d6d878108fc3ac97826756c355b0c8b748143253" => :high_sierra
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "make"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end
